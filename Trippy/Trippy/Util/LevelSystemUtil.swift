//
//  LevelSystemUtil.swift
//  Trippy
//
//  Created by Audrey Felicio Anwar on 30/3/21.
//

import Foundation

class LevelSystemUtil {
    static func getExperienceFrom(action: ExperienceAction) -> Int {
        switch action {
        case .AddFriend:
            return LevelSystemConstants.addFriendExp
        case .FinishBucketItem:
            return LevelSystemConstants.finishBucketItemExp
        case .JoinMeetup:
            return LevelSystemConstants.joinMeetupExp
        }
    }

    static func generateExperienceToLevelUp(currentLevel: Int) -> Int {
        let baseExp = Double(LevelSystemConstants.baseExp)
        let exponentialConstant = LevelSystemConstants.exponentialConstant
        let power = Double(currentLevel - 1)
        return Int(ceil(baseExp * pow(exponentialConstant, power)))
    }
}
