//
//  FBAchievementService.swift
//  Trippy
//
//  Created by Audrey Felicio Anwar on 11/4/21.
//

import Combine

class FBAchievementService: AchievementService {
    var userStorage: FBImageSupportedStorage<FBUser>
    var achievementStorage = FBImageSupportedStorage<FBAchievement>()
    @Published var trippyAchievements = [Achievement]()
    private var cancellables: Set<AnyCancellable> = []

    init(userStorage: FBImageSupportedStorage<FBUser>) {
        self.userStorage = userStorage
        self.achievementStorage.fetch()
        self.achievementStorage.storedItems.assign(to: \.trippyAchievements, on: self).store(in: &self.cancellables)
    }

    func completeAchievements(for user: User, achievement: [Achievement]) {
        if achievement.isEmpty {
            return
        }
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
            friendsId: user.friendsId,
            levelSystemId: user.levelSystemId,
            achievements: newCompletedAchievements,
            imageURL: user.imageURL
        )
        do {
            try userStorage.update(newUser)
        } catch {
            print(error.localizedDescription)
        }
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
