//
//  DetailsViewController.swift
//  EglenceSepeti
//
//  Created by Mac on 9.02.2023.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import SDWebImage

class DetailsViewController: UIViewController {
    
    @IBOutlet weak var detailsDescription: UILabel!
    @IBOutlet weak var detailsTime: UILabel!
    @IBOutlet weak var detailsDate: UILabel!
    @IBOutlet weak var detailsLocation: UILabel!
    @IBOutlet weak var detailsTitle: UILabel!
    @IBOutlet weak var detailsImageView: UIImageView!
    
    var postArray = [Post]()
    var choosen = Post(title: "", description: "", imageUrl: "", date: "", location: "", email: "", time: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firebaseGetDetailsData()
        initialSetup()
        
    }
    
    func firebaseGetDetailsData(){
        self.detailsTitle.text = self.choosen.title
        self.detailsImageView.sd_setImage(with: URL(string: self.choosen.imageUrl))
        self.detailsLocation.text = self.choosen.location
        self.detailsDate.text = self.choosen.date
        self.detailsTime.text = self.choosen.time
        self.detailsDescription.text = self.choosen.description
    }
    func initialSetup() {
        let myImage = detailsImageView.layer
        
        let myColor : UIColor = UIColor(red: 255/255, green: 115/255, blue: 165/255, alpha: 1)
        
        myImage.cornerRadius = 20
        myImage.borderWidth = 2.0
        myImage.borderColor = myColor.cgColor
        myImage.masksToBounds = true
    }
    
    
    
    
}
