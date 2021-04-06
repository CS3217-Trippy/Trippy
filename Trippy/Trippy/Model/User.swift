//
//  User.swift
//  Trippy
//
//  Created by Audrey Felicio Anwar on 14/3/21.
//

import Foundation

class User: Model {
    var imageURL: URL?
    var id: String?
    var email: String
    var username: String
    var friendsId: [String]
    var levelSystemId: String
    var profilePhoto = "https://timesofindia.indiatimes.com/photo/67586673.cms"

    init(
        id: String?,
        email: String,
        username: String,
        friendsId: [String],
        levelSystemId: String,
        imageURL: URL? = nil
    ) {
        self.id = id
        self.email = email
        self.username = username
        self.friendsId = friendsId
        self.levelSystemId = levelSystemId
        self.imageURL = imageURL
    }
}
