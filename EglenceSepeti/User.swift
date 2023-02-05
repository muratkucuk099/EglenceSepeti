//
//  User.swift
//  EglenceSepeti
//
//  Created by Mac on 10.02.2023.
//

import Foundation

class User {
    var name : String
    var description : String
    var email : String
    var password : String
    
    init(name: String, description: String, email: String, password: String) {
        self.name = name
        self.description = description
        self.email = email
        self.password = password
    }
    
}
