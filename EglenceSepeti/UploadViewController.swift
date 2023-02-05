//
//  UploadViewController.swift
//  EglenceSepeti
//
//  Created by Mac on 6.02.2023.
//

import UIKit
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth

class UploadViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var eventNameTextfield: UITextField!
    @IBOutlet weak var eventLocationTextfield: UITextField!
    @IBOutlet weak var eventDateTextfield: UITextField!
    @IBOutlet weak var eventTimeTextfield: UITextField!
    @IBOutlet weak var eventDescriptionTextfield: UITextField!
    @IBOutlet weak var createButtonNoAction: UIButton!
    
    override func viewDidLoad() {
        initialSetup()
        super.viewDidLoad()
        imageView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imagePick))
        imageView.addGestureRecognizer(gestureRecognizer)
        let gestureRecognizerKeyboard = UITapGestureRecognizer(target: self, action: #selector(turnOffKeyboard))
        view.addGestureRecognizer(gestureRecognizerKeyboard)
        
        // Do any additional setup after loading the view.
        imageViewSetup()
    }
    func imageViewSetup() {
        
        let myImage = imageView.layer
        let myColor : UIColor = UIColor(red: 255/255, green: 115/255, blue: 165/255, alpha: 1)
        
        myImage.cornerRadius = 20
        myImage.borderWidth = 2.0
        myImage.borderColor = myColor.cgColor
        myImage.masksToBounds = true
    }
    
    @objc func imagePick(){
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[.editedImage] as? UIImage
        self.dismiss(animated: true)
    }
    private func initialSetup() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification: )), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(chageFrame), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        if let keyboardFrame : NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardHeight = keyboardFrame.cgRectValue.height
            let bottomSpace = self.view.frame.height - (createButtonNoAction.frame.origin.y + createButtonNoAction.frame.height )
            self.view.frame.origin.y -= keyboardHeight - bottomSpace
        }
    }
    
    @objc private func keyboardWillHide() {
        self.view.frame.origin.y = 0
    }
    @objc private func chageFrame() {
        view.frame.origin.y = 0
    }
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    @objc func turnOffKeyboard() {
        view.endEditing(true)
    }
    
    
    @IBAction func createEventButton(_ sender: Any) {
        
        let storage = Storage.storage()
        let storageReference = storage.reference()
        let mediaFolder = storageReference.child("media")
        
        if let data = imageView.image?.jpegData(compressionQuality: 0.5) {
            let uuid = UUID().uuidString
            let imageReference = mediaFolder.child("\(uuid).jpg")
            
            imageReference.putData(data) { StorageMetadata, error in
                if error != nil {
                    self.errorMessage(message: error?.localizedDescription ?? "Try Again")
                } else {
                    
                    imageReference.downloadURL { url, error in
                        if error == nil {
                            
                            let imageUrl = url?.absoluteString
                            if let imageUrl = imageUrl {
                                
                                let firestoreDatabase = Firestore.firestore()
                                let firestorePost = ["imageUrl" : imageUrl, "title" : self.eventNameTextfield.text!, "location" : self.eventLocationTextfield.text!, "date" : self.eventDateTextfield.text!, "time" : self.eventTimeTextfield.text!, "description" : self.eventDescriptionTextfield.text!, "email" : Auth.auth().currentUser!.email as Any, "uploadTime" : FieldValue.serverTimestamp()] as [String : Any]
                                
                                firestoreDatabase.collection("Post").addDocument(data: firestorePost) { error in
                                    if error != nil {
                                        self.errorMessage(message: error?.localizedDescription ?? "Try Again")
                                    } else {
                                        self.eventNameTextfield.text = ""
                                        self.eventLocationTextfield.text = ""
                                        self.eventDateTextfield.text = ""
                                        self.eventTimeTextfield.text = ""
                                        self.eventDescriptionTextfield.text = ""
                                        self.imageView.image = UIImage(named: "Ekran Resmi 2023-02-02 21.48.58")
                                        self.tabBarController?.selectedIndex = 0
                                    }
                                }
                            }
                            
                        }
                    }
                    
                }
            }
        }
    }
    
    func errorMessage(message : String){
        let alert = UIAlertController(title: "Error!", message: message, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
        alert.addAction(okButton)
        present(alert, animated: true)
    }
    
}
