//
//  FBLevelSystem.swift
//  Trippy
//
//  Created by Audrey Felicio Anwar on 30/3/21.
//

import Foundation
import FirebaseFirestoreSwift

/// Represents a level system specific to firebase storage solution
struct FBLevelSystem: FBStorable {
    typealias ModelType = LevelSystem
    static var path = "levelSystem"
    @DocumentID var id: String?
    var userId: String
    var experience: Int
    var level: Int
    var friendsIdAddedBefore: [String]
    var bucketItemsAddedBefore: [String]
    var meetupsJoinedBefore: [String]

    init(item: LevelSystem) {
        self.id = item.id
        self.userId = item.userId
        self.experience = item.experience
        self.level = item.level
        self.friendsIdAddedBefore = item.friendsIdAddedBefore
        self.bucketItemsAddedBefore = item.bucketItemsAddedBefore
        self.meetupsJoinedBefore = item.meetupsJoinedBefore
    }

    /// Converts from storage specific to general model
    func convertToModelType() -> LevelSystem {
        LevelSystem(
            userId: userId,
            id: id,
            experience: experience,
            level: level,
            friendsIdAddedBefore: friendsIdAddedBefore,
            bucketItemsAddedBefore: bucketItemsAddedBefore,
            meetupsJoinedBefore: meetupsJoinedBefore
        )
    }
}
