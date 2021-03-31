//
//  FBLevelSystemService.swift
//  Trippy
//
//  Created by Audrey Felicio Anwar on 30/3/21.
//

import Foundation
import Combine

final class FBLevelSystemService: LevelSystemService, ObservableObject {
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

    private func updateLevelSystem(userLevelSystem: LevelSystem) {
        do {
            try levelSystemStorage.update(item: userLevelSystem)
        } catch {
            print(error.localizedDescription)
        }
    }

    private func addExperience(action: ExperienceAction, userLevelSystem: LevelSystem) {
        let currentExperience = userLevelSystem.experience
        let expToAdd = LevelSystemUtil.getExperienceFrom(action: action)
        let experienceToNextLevel = LevelSystemUtil.generateExperienceToLevelUp(currentLevel: userLevelSystem.level)
        if currentExperience + expToAdd >= experienceToNextLevel {
            userLevelSystem.level += 1
            userLevelSystem.experience = currentExperience + expToAdd - experienceToNextLevel
        } else {
            userLevelSystem.experience += expToAdd
        }
    }

    func generateExperienceFromAddingFriend(friend: Friend) {
        levelSystemStorage.fetchWithId(id: friend.friendId) { friendLevelSystem in
            let friendAddedFriends = friendLevelSystem.friendsIdAddedBefore
            if friendAddedFriends.contains(friend.userId) {
                return
            }
            friendLevelSystem.friendsIdAddedBefore.append(friend.userId)
            self.addExperience(action: .AddFriend, userLevelSystem: friendLevelSystem)
            self.updateLevelSystem(userLevelSystem: friendLevelSystem)
        }
        let userLevelSystem = getUserLevelSystem()
        let userAddedFriends = userLevelSystem.friendsIdAddedBefore
        if userAddedFriends.contains(friend.friendId) {
            return
        }
        userLevelSystem.friendsIdAddedBefore.append(friend.friendId)
        addExperience(action: .AddFriend, userLevelSystem: userLevelSystem)
        updateLevelSystem(userLevelSystem: userLevelSystem)
    }

    func generateExperienceProgressData() -> (Int, Double) {
        let userLevelSystem = getUserLevelSystem()
        let currentExperience = userLevelSystem.experience
        let experienceToNextLevel = LevelSystemUtil.generateExperienceToLevelUp(currentLevel: userLevelSystem.level)
        return (experienceToNextLevel, Double(currentExperience) / Double(experienceToNextLevel) * 100)
    }
}
