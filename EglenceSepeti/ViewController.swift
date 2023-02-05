//
//  ViewController.swift
//  EglenceSepeti
//
//  Created by Mac on 5.02.2023.
//

import UIKit
import FirebaseAuth


class ViewController: UIViewController {
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var signInButton: UIButton!
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
            let bottomSpace = self.view.frame.height - (signInButton.frame.origin.y + signInButton.frame.height)
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
    @IBAction func signInButtonFunction(_ sender: Any) {
      
        if emailTextfield.text != "" && passwordTextfield.text != "" {
            Auth.auth().signIn(withEmail: emailTextfield.text!, password: passwordTextfield.text!) { authresult, error in
                if error != nil {
                    self.errorFunction(title: "Error!", message: error?.localizedDescription ?? "Try Again")
                } else {
                    self.performSegue(withIdentifier: "MainPage", sender: nil)
                }
            }
        } else {
            errorFunction(title: "Error!", message: "You can not enter null input")
        }
    }
    
    @IBAction func signUpButtonFunction(_ sender: Any) {
        performSegue(withIdentifier: "SignUp", sender: nil)
    }
    func errorFunction(title : String, message : String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
        alert.addAction(okButton)
        self.present(alert, animated: true)
        
    }
    
    
    
}

