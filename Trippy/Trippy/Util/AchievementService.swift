//
//  AchievementService.swift
//  Trippy
//
//  Created by Audrey Felicio Anwar on 11/4/21.
//

import Foundation

protocol AchievementService {
    func completeAchievements(for user: User, achievement: [Achievement])

    func checkForCompletions(type: AchievementType, completion: Int) -> [Achievement]
}
