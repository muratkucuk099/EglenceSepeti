//
//  MyProfileViewController.swift
//  EglenceSepeti
//
//  Created by Mac on 6.02.2023.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class MyProfileViewController: UIViewController {

    @IBOutlet weak var descriptionTextfield: UILabel!
    @IBOutlet weak var emailTextField: UILabel!
    @IBOutlet weak var nameTextfield: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        firebaseGetUser()
    }
    
    @IBAction func signOutFunctionButton(_ sender: Any) {
        do {
            try Auth.auth().signOut()
        }
        catch {
            
        }
        performSegue(withIdentifier: "toLogin", sender: nil)
    }
    
    func firebaseGetUser() {
        let firestoreDatabase = Firestore.firestore()
        
        firestoreDatabase.collection("Users")
            .addSnapshotListener { snapshot, error in
            if error != nil {
                
            } else {
                for document in snapshot!.documents {
                    if Auth.auth().currentUser?.email == document.get("email") as! String {
                        self.nameTextfield.text! = document.get("name") as! String
                        self.emailTextField.text! = document.get("email") as! String
                        self.descriptionTextfield.text! = document.get("description") as! String
                    }
                }
            }
        }
    }
    
    

}
