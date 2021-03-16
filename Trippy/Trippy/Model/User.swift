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
    var followersId: [String]
    var followingId: [String]

    init(id: String, email: String, username: String, followersId: [String], followingId: [String]) {
        self.id = id
        self.email = email
        self.username = username
        self.followersId = followersId
        self.followingId = followingId
    }
}
