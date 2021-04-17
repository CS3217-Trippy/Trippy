//
//  FBLevelSystemService.swift
//  Trippy
//
//  Created by Audrey Felicio Anwar on 30/3/21.
//

import Foundation
import Combine

final class FBLevelSystemService: LevelSystemService, ObservableObject {
    private var userId: String
    var achievementService: AchievementService
    var levelSystemStorage: FBStorage<FBLevelSystem>
    @Published var levelSystem = [LevelSystem]()
    private var cancellables: Set<AnyCancellable> = []

    init(userId: String, achievementService: AchievementService) {
        self.userId = userId
        self.achievementService = achievementService
        self.levelSystemStorage = FBStorage<FBLevelSystem>()
        self.levelSystemStorage.storedItems.assign(to: \.levelSystem, on: self).store(in: &self.cancellables)
    }

    func getUserLevelSystem() -> LevelSystem {
        if levelSystem.count != 1 {
            fatalError("User should have level system")
        }
        return levelSystem[0]
    }

    func createLevelSystem(userId: String) {
        let newLevelSystemForUser = LevelSystem(
            userId: userId,
            id: userId,
            experience: 0,
            level: 1,
            friendsIdAddedBefore: [],
            bucketItemsAddedBefore: [],
            meetupsJoinedBefore: []
        )
        retrieveLevelSystem()
        do {
            try levelSystemStorage.add(item: newLevelSystemForUser)
        } catch {
            print(error.localizedDescription)
        }
    }

    func retrieveLevelSystem() {
        self.levelSystemStorage.fetchWithField(field: "userId", value: userId, handler: nil)
    }

    private func updateLevelSystem(userLevelSystem: LevelSystem) {
        do {
            try levelSystemStorage.update(item: userLevelSystem) { _ in
                let completionFriend = userLevelSystem.friendsIdAddedBefore.count
                let completionBucket = userLevelSystem.bucketItemsAddedBefore.count
                let completionMeetup = userLevelSystem.meetupsJoinedBefore.count
                let completedFriendAchievements = self.achievementService.checkForCompletions(
                    type: .FriendCount(completion: 0), completion: completionFriend
                )
                let completedBucketAchievements = self.achievementService.checkForCompletions(
                    type: .BucketItemCount(completion: 0), completion: completionBucket
                )
                let completedMeetupAchievements = self.achievementService.checkForCompletions(
                    type: .MeetupCount(completion: 0), completion: completionMeetup
                )
                self.achievementService.completeAchievements(
                    for: self.userId,
                    achievement: completedFriendAchievements + completedBucketAchievements + completedMeetupAchievements
                )
                self.generateExperienceFromCompletingAchievements(
                    achievements: completedFriendAchievements +
                        completedBucketAchievements + completedMeetupAchievements,
                    levelSystem: userLevelSystem
                )
            }
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

    private func addExperienceWithSetAmount(toAdd: Int, userLevelSystem: LevelSystem) {
        let currentExperience = userLevelSystem.experience
        let experienceToNextLevel = LevelSystemUtil.generateExperienceToLevelUp(currentLevel: userLevelSystem.level)
        if currentExperience + toAdd >= experienceToNextLevel {
            userLevelSystem.level += 1
            userLevelSystem.experience = currentExperience + toAdd - experienceToNextLevel
        } else {
            userLevelSystem.experience += toAdd
        }
    }

    private func generateExperienceFromCompletingAchievements(achievements: [Achievement], levelSystem: LevelSystem) {
        for achievement in achievements {
            let exp = achievement.exp
            addExperienceWithSetAmount(toAdd: exp, userLevelSystem: levelSystem)
        }
        do {
            try levelSystemStorage.update(item: levelSystem, handler: nil)
        } catch {
            print(error.localizedDescription)
        }
    }

    func generateExperienceFromAddingFriend(friend: Friend) {
        let friendLevelSystemService = FBLevelSystemService(
            userId: friend.friendId,
            achievementService: achievementService
        )
        let friendLevelSystemStorage = friendLevelSystemService.levelSystemStorage
        friendLevelSystemStorage.fetchWithId(id: friend.friendId) { friendLevelSystem in
            let friendAddedFriends = friendLevelSystem.friendsIdAddedBefore
            if friendAddedFriends.contains(friend.userId) {
                return
            }
            friendLevelSystem.friendsIdAddedBefore.append(friend.userId)
            friendLevelSystemService.addExperience(action: .AddFriend, userLevelSystem: friendLevelSystem)
            friendLevelSystemService.updateLevelSystem(userLevelSystem: friendLevelSystem)
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

    func generateExperienceFromFinishingBucketItem(bucketItem: BucketItem) {
        if bucketItem.dateVisited == nil {
            return
        }
        guard let id = bucketItem.id else {
            return
        }
        let userLevelSystem = getUserLevelSystem()
        if userLevelSystem.bucketItemsAddedBefore.contains(id) {
            return
        }
        userLevelSystem.bucketItemsAddedBefore.append(id)
        addExperience(action: .FinishBucketItem, userLevelSystem: userLevelSystem)
        updateLevelSystem(userLevelSystem: userLevelSystem)
    }

    func generateExperienceFromJoiningMeetup(meetup: Meetup) {
        let userLevelSystem = getUserLevelSystem()
        if meetup.hostUserId == userLevelSystem.userId || meetup.meetupPrivacy == MeetupPrivacy.privateMeetup {
            return
        }
        guard let id = meetup.id else {
            return
        }
        if userLevelSystem.meetupsJoinedBefore.contains(id) {
            return
        }
        userLevelSystem.meetupsJoinedBefore.append(id)
        addExperience(action: .JoinMeetup, userLevelSystem: userLevelSystem)
        updateLevelSystem(userLevelSystem: userLevelSystem)
    }

    func generateExperienceProgressData() -> (Int, Double) {
        let userLevelSystem = getUserLevelSystem()
        let currentExperience = userLevelSystem.experience
        let experienceToNextLevel = LevelSystemUtil.generateExperienceToLevelUp(currentLevel: userLevelSystem.level)
        let percentage = Double(currentExperience) / Double(experienceToNextLevel) * 100
        return (experienceToNextLevel, percentage)
    }
}
