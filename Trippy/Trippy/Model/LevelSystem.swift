//
//  LevelSystem.swift
//  Trippy
//
//  Created by Audrey Felicio Anwar on 30/3/21.
//

import Foundation

class LevelSystem: Model {
    var userId: String
    var id: String?
    var experience: Int
    var level: Int
    var friendsIdAddedBefore: [String]
    var bucketItemsAddedBefore: [String]

    init(
        userId: String,
        id: String?,
        experience: Int,
        level: Int,
        friendsIdAddedBefore: [String],
        bucketItemsAddedBefore: [String]
    ) {
        self.userId = userId
        self.id = id
        self.experience = experience
        self.level = level
        self.friendsIdAddedBefore = friendsIdAddedBefore
        self.bucketItemsAddedBefore = bucketItemsAddedBefore
    }
}
