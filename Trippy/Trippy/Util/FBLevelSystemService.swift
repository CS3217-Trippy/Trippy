//
//  FBLevelSystemService.swift
//  Trippy
//
//  Created by Audrey Felicio Anwar on 30/3/21.
//

import Foundation
import Combine

final class FBLevelSystemService: LevelSystemService {
    var levelSystemStorage: FBUserRelatedStorage<FBLevelSystem>
    @Published var levelSystem = [LevelSystem]()
    private var cancellables: Set<AnyCancellable> = []

    init(userId: String) {
        self.levelSystemStorage = FBUserRelatedStorage<FBLevelSystem>(userId: userId)
        self.levelSystemStorage.storedItems.assign(to: \.levelSystem, on: self).store(in: &self.cancellables)
    }

    func getUserLevelSystem() -> LevelSystem {
        if levelSystem.count != 1 {
            fatalError("User should have level system")
        }
        return levelSystem[0]
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

    func retrieveLevelSystem() {
        self.levelSystemStorage.fetch()
    }

    func updateLevelSystem() {
        let userLevelSystem = getUserLevelSystem()
        do {
            try levelSystemStorage.update(item: userLevelSystem)
        } catch {
            print(error.localizedDescription)
        }
    }

    func addExperience(action: ExperienceAction) {
        let userLevelSystem = getUserLevelSystem()
        let currentExperience = userLevelSystem.experience
        let expToAdd = LevelSystemUtil.getExperienceFrom(action: action)
        let experienceToNextLevel = LevelSystemUtil.generateExperienceToLevelUp(currentLevel: userLevelSystem.level)
        if currentExperience + expToAdd >= experienceToNextLevel {
            userLevelSystem.level += 1
            userLevelSystem.experience = currentExperience + expToAdd - experienceToNextLevel
        } else {
            userLevelSystem.experience += expToAdd
        }
        updateLevelSystem()
    }

    func generateExperienceFromAddingFriend(friend: Friend) {
        let userLevelSystem = getUserLevelSystem()
        let userAddedFriends = userLevelSystem.friendsIdAddedBefore
        if userAddedFriends.contains(friend.friendId) {
            return
        }
        userLevelSystem.friendsIdAddedBefore.append(friend.friendId)
        addExperience(action: .AddFriend)
    }
}
