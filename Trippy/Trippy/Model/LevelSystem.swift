//
//  LevelSystem.swift
//  Trippy
//
//  Created by Audrey Felicio Anwar on 30/3/21.
//

import Foundation

class LevelSystem: UserRelatedModel {
    var userId: String
    var id: String?
    var experience: Int
    var level: Int
    var friendsIdAddedBefore: [String]

    init(
        userId: String,
        id: String?,
        experience: Int,
        level: Int,
        friendsIdAddedBefore: [String]
    ) {
        self.userId = userId
        self.id = id
        self.experience = experience
        self.level = level
        self.friendsIdAddedBefore = friendsIdAddedBefore
    }
}
