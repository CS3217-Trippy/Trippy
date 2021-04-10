//
//  FBAchievementService.swift
//  Trippy
//
//  Created by Audrey Felicio Anwar on 11/4/21.
//

import Combine

class FBAchievementService: AchievementService {
    var achievementStorage = FBImageSupportedStorage<FBAchievement>()
    @Published var trippyAchievements = [Achievement]()
    private var cancellables: Set<AnyCancellable> = []

    init() {
        self.achievementStorage.storedItems.assign(to: \.trippyAchievements, on: self).store(in: &self.cancellables)
    }

    func completeAchievements(for user: User, achievement: [Achievement]) {
        return
    }

    func checkForCompletions(type: AchievementType, completion: Int) -> [Achievement] {
        var completedAchievements = [Achievement]()
        for achievement in trippyAchievements {
            let achievementTypeName = achievement.achievementType.getTypeDescription()
            let achievementCompletion = achievement.achievementType.getCompletion()
            let typeNameToCompare = type.getTypeDescription()
            let completionToCompare = type.getCompletion()
            if achievementTypeName != typeNameToCompare {
                continue
            }
            if completionToCompare >= achievementCompletion {
                completedAchievements.append(achievement)
            }
        }
        return completedAchievements
    }
}
