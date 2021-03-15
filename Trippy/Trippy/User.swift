//
//  User.swift
//  Trippy
//
//  Created by Audrey Felicio Anwar on 14/3/21.
//

import Foundation

class User: Identifiable, Codable {
    var id: String
    var email: String
    var username: String
    
    init(id: String, email: String, username: String) {
        self.id = id
        self.email = email
        self.username = username
    }
}
