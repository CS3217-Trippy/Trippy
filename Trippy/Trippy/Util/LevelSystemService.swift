//
//  LevelSystemService.swift
//  Trippy
//
//  Created by Audrey Felicio Anwar on 30/3/21.
//

import Foundation

protocol LevelSystemService {
    var achievementService: AchievementService { get set }

    func createLevelSystem(userId: String)

    func getUserLevelSystem() -> LevelSystem

    func retrieveLevelSystem()

    func generateExperienceFromAddingFriend(friend: Friend)

    func generateExperienceFromFinishingBucketItem(bucketItem: BucketItem)

    func generateExperienceFromJoiningMeetup(meetup: Meetup)

    func generateExperienceProgressData() -> (Int, Double)
}
