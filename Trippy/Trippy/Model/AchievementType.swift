//
//  AchievementType.swift
//  Trippy
//
//  Created by Audrey Felicio Anwar on 11/4/21.
//

import Foundation

enum AchievementType {
    case FriendCount(completion: Int)
    case BucketItemCount(completion: Int)

    func getCompletion() -> Int {
        switch self {
        case .FriendCount(let completion):
            return completion
        case .BucketItemCount(let completion):
            return completion
        }
    }

    func getTypeDescription() -> String {
        switch self {
        case .FriendCount:
            return "friendCount"
        case .BucketItemCount:
            return "bucketItemCount"
        }
    }

    static func generateAchievementType(type: String, completion: Int) -> AchievementType {
        if type == "friendCount" {
            return .FriendCount(completion: completion)
        } else if type == "bucketItemCount" {
            return .BucketItemCount(completion: completion)
        } else {
            fatalError("Undefined achievement type")
        }
    }
}