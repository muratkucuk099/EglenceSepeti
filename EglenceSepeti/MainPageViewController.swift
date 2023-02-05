//
//  MainPageViewController.swift
//  EglenceSepeti
//
//  Created by Mac on 6.02.2023.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import SDWebImage

class MainPageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var postArray = [Post]()
    var choosenPost = Post(title: "", description: "", imageUrl: "", date: "", location: "", email: "", time: "")
      
    @IBOutlet weak var tableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        firebaseGetData()

        // Do any additional setup after loading the view.
    }
    func firebaseGetData() {
        
        let firestoreDatabase = Firestore.firestore()
        
        firestoreDatabase.collection("Post").order(by: "uploadTime", descending: true )
            .addSnapshotListener { snapshot, error in
            if error != nil {
                
            } else {
                if snapshot?.isEmpty == false && snapshot != nil {
                    
                    self.postArray.removeAll()
                    
                    for document in snapshot!.documents {
                        document.get("imageUrl")
                        
                       if let imageUrl = document.get("imageUrl") as? String {
                           if let title = document.get("title") as? String {
                               if let location = document.get("location") as? String {
                                   if let description = document.get("description") as? String {
                                       if let date = document.get("date") as? String {
                                           if let email = document.get("email") as? String {
                                               if let time = document.get("time") as? String {
                                                  let post = Post(title: title, description: description, imageUrl: imageUrl, date: date, location: location, email: email, time: time)
                                                   self.postArray.append(post)
                                               }
                                               
                                           }
                                       }
                                   }
                               }
                           }
                        }
    
                    }
                    self.tableView.reloadData()
                }
            }
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        cell.eventDateLabel.text = postArray[indexPath.row].date
        cell.eventNameLabel.text = postArray[indexPath.row].title
        cell.locationLabel.text = postArray[indexPath.row].location
        cell.postImageView.sd_setImage(with: URL(string:  self.postArray[indexPath.row].imageUrl))
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DetailsVC" {
            let detailsVC = segue.destination as! DetailsViewController
            detailsVC.choosen = choosenPost
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        choosenPost = postArray[indexPath.row]
        performSegue(withIdentifier: "DetailsVC", sender: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    

  

}
