//
//  User.swift
//  Trippy
//
//  Created by Audrey Felicio Anwar on 14/3/21.
//

import Foundation

class User: ImageSupportedModel {
    var imageURL: URL?
    var id: String?
    var email: String
    var username: String
    var friendsId: [String]

    init(id: String?, email: String, username: String, friendsId: [String]) {
        self.id = id
        self.email = email
        self.username = username
        self.friendsId = friendsId
    }
}
