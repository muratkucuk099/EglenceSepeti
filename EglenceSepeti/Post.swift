//
//  Post.swift
//  EglenceSepeti
//
//  Created by Mac on 9.02.2023.
//

import Foundation

class Post {
    
    var title : String
    var description : String
    var imageUrl : String
    var date : String
    var location : String
    var email : String
    var time : String
    
    init(title: String, description: String, imageUrl: String, date: String, location: String, email: String, time: String) {
        self.title = title
        self.description = description
        self.imageUrl = imageUrl
        self.date = date
        self.location = location
        self.email = email
        self.time = time
    }
    
    
}
