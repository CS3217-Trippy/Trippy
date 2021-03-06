//
//  FBAchievementService.swift
//  Trippy
//
//  Created by Audrey Felicio Anwar on 11/4/21.
//

import Combine

class FBAchievementService: AchievementService {
    var userStorage = FBStorage<FBUser>()
    var achievementStorage = FBStorage<FBAchievement>()
    @Published var trippyAchievements = [Achievement]()
    private var cancellables: Set<AnyCancellable> = []

    init() {
        self.achievementStorage.fetch(handler: nil)
        self.achievementStorage.storedItems.assign(to: \.trippyAchievements, on: self).store(in: &self.cancellables)
    }

    func completeAchievements(for id: String, achievement: [Achievement]) {
        if achievement.isEmpty {
            return
        }
        userStorage.fetchWithId(id: id) { user in
            let userCompletedAchievemnets = user.achievements
            var newCompletedAchievements = user.achievements
            for completed in achievement {
                if userCompletedAchievemnets.contains(where: { $0 == completed.id }) {
                    continue
                }
                guard let id = completed.id else {
                    continue
                }
                newCompletedAchievements.append(id)
            }
            let newUser = User(
                id: user.id,
                email: user.email,
                username: user.username,
                levelSystemId: user.levelSystemId,
                achievements: newCompletedAchievements,
                imageId: user.imageId
            )
            do {
                try self.userStorage.update(item: newUser, handler: nil)
            } catch {
                print(error.localizedDescription)
            }
        }
    }

    func checkForCompletions(type: AchievementType, completion: Int) -> [Achievement] {
        var completedAchievements = [Achievement]()
        for achievement in trippyAchievements {
            let achievementTypeName = achievement.achievementType.getTypeDescription()
            let achievementCompletion = achievement.achievementType.getCompletion()
            let typeNameToCompare = type.getTypeDescription()
            if achievementTypeName != typeNameToCompare {
                continue
            }
            if completion >= achievementCompletion {
                completedAchievements.append(achievement)
            }
        }
        return completedAchievements
    }
}
