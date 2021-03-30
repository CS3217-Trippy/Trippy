//
//  FBLevelSystemService.swift
//  Trippy
//
//  Created by Audrey Felicio Anwar on 30/3/21.
//

import Foundation

final class FBLevelSystemService: LevelSystemService {
    var levelSystemStorage: FBUserRelatedStorage<FBLevelSystem>

    init(userId: String) {
        self.levelSystemStorage = FBUserRelatedStorage<FBLevelSystem>(userId: userId)
    }

    func createLevelSystem() {
        guard let userId = levelSystemStorage.userId else {
            fatalError("User Id should have been specified")
        }
        let newLevelSystemForUser = LevelSystem(
            userId: userId,
            id: userId,
            experience: 0,
            level: 1,
            friendsIdAddedBefore: []
        )
        do {
            try levelSystemStorage.add(item: newLevelSystemForUser)
        } catch {
            print(error.localizedDescription)
        }
    }
}
