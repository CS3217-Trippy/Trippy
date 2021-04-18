//
//  AchievementType.swift
//  Trippy
//
//  Created by Audrey Felicio Anwar on 11/4/21.
//

import Foundation

/// An encapsulation of possible achievement types for Trippy
enum AchievementType {
    case FriendCount(completion: Int)
    case BucketItemCount(completion: Int)
    case MeetupCount(completion: Int)

    /// Get completion associated value
    func getCompletion() -> Int {
        switch self {
        case .FriendCount(let completion):
            return completion
        case .BucketItemCount(let completion):
            return completion
        case .MeetupCount(let completion):
            return completion
        }
    }

    /// Get description for an achievement type
    func getTypeDescription() -> String {
        switch self {
        case .FriendCount:
            return "friendCount"
        case .BucketItemCount:
            return "bucketItemCount"
        case .MeetupCount:
            return "meetupCount"
        }
    }

    /// Generate a new instance of AchievementType
    /// - parameters:
    /// type: A string describing the achievement type to be generated
    /// completion: The current count for completion of achievement
    static func generateAchievementType(type: String, completion: Int) -> AchievementType {
        if type == "friendCount" {
            return .FriendCount(completion: completion)
        } else if type == "bucketItemCount" {
            return .BucketItemCount(completion: completion)
        } else if type == "meetupCount" {
            return .MeetupCount(completion: completion)
        } else {
            fatalError("Undefined achievement type")
        }
    }
}
