//
//  User.swift
//  Trippy
//
//  Created by Audrey Felicio Anwar on 14/3/21.
//

import Foundation
import UIKit

/// A class describing a user
class User: Model {
    var imageId: String?
    var id: String?
    var email: String
    var username: String
    var friendsId: [String]
    var levelSystemId: String
    var achievements: [String]

    init(
        id: String?,
        email: String,
        username: String,
        friendsId: [String],
        levelSystemId: String,
        achievements: [String],
        imageId: String?
    ) {
        self.id = id
        self.email = email
        self.username = username
        self.friendsId = friendsId
        self.levelSystemId = levelSystemId
        self.achievements = achievements
        self.imageId = imageId
    }
}
