//
//  SignUpViewController.swift
//  EglenceSepeti
//
//  Created by Mac on 6.02.2023.
//

import UIKit
import FirebaseAuth
import FirebaseCore
import FirebaseStorage
import FirebaseFirestore

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var emailtextField: UITextField!
    @IBOutlet weak var nameTextfield: UITextField!
    @IBOutlet weak var signUpButtonNoFunction: UIButton!
    @IBOutlet weak var descriptionTextfield: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let gestureRecognizerKeyboard = UITapGestureRecognizer(target: self, action: #selector(turnOffKeyboard))
        view.addGestureRecognizer(gestureRecognizerKeyboard)
        initialSetup()
    }
    private func initialSetup() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification: )), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(chageFrame), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        if let keyboardFrame : NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardHeight = keyboardFrame.cgRectValue.height
            let bottomSpace = self.view.frame.height - (signUpButtonNoFunction.frame.origin.y + signUpButtonNoFunction.frame.height)
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
    
    @IBAction func signUpFunctionButton(_ sender: Any) {
        
        let storage = Storage.storage()
        let storageReference = storage.reference()
        let mediaFolder = storageReference.child("Users")
        let firestoreDatabase = Firestore.firestore()
        
        if emailtextField.text != "" && passwordTextfield.text != "" && nameTextfield.text != "" && descriptionTextfield.text != "" {
            let firestoreUser = ["name" : self.nameTextfield.text!, "description" : self.descriptionTextfield.text!, "email" : self.emailtextField.text!, "password" : self.passwordTextfield.text!] as [String : Any]
            
            firestoreDatabase.collection("Users").addDocument(data: firestoreUser) { error in
                
                if error != nil {
                    self.errorFunction(title: "Error!", message: error?.localizedDescription ?? "Try Again")
                } else {
                    self.passwordTextfield.text = ""
                    self.emailtextField.text = ""
                    self.nameTextfield.text = ""
                    self.descriptionTextfield.text = ""
                }
            }
            
            
            Auth.auth().createUser(withEmail: emailtextField.text!, password: passwordTextfield.text!) { authdataresult, error in
                if error != nil {
                    self.errorFunction(title: "Error!", message: error?.localizedDescription ?? "Try Again")
                } else {
                    self.performSegue(withIdentifier: "toMainPage", sender: nil)
                }
            }
            
        } else {
            errorFunction(title: "Error!", message: "You can not enter null input!")
        }
    }
    
    func errorFunction(title : String, message : String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
        alert.addAction(okButton)
        self.present(alert, animated: true)
        
    }
    
   

}
