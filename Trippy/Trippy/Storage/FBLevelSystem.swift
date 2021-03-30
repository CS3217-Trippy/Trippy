//
//  FBLevelSystem.swift
//  Trippy
//
//  Created by Audrey Felicio Anwar on 30/3/21.
//

import Foundation
import FirebaseFirestoreSwift

struct FBLevelSystem: FBUserRelatedStorable {
    typealias ModelType = LevelSystem
    static var path = "levelSystem"
    @DocumentID var id: String?
    var userId: String
    var experience: Int
    var level: Int
    var friendsIdAddedBefore: [String]

    init(item: LevelSystem) {
        self.id = item.id
        self.userId = item.userId
        self.experience = item.experience
        self.level = item.level
        self.friendsIdAddedBefore = item.friendsIdAddedBefore
    }

    func convertToModelType() -> LevelSystem {
        return LevelSystem(
            userId: userId,
            id: id,
            experience: experience,
            level: level,
            friendsIdAddedBefore: friendsIdAddedBefore
        )
    }
}
