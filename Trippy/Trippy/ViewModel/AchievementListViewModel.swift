//
//  AchievementListViewModel.swift
//  Trippy
//
//  Created by Audrey Felicio Anwar on 13/4/21.
//

import Combine
import SwiftUI

final class AchievementListViewModel: ObservableObject {
    private var achievementModel: AchievementModel<FBStorage<FBAchievement>>
    @Published var achievementItemViewModels: [AchievementItemViewModel] = []
    private var user: User
    private let imageModel: ImageModel
    private var cancellables: Set<AnyCancellable> = []

    init(achievementModel: AchievementModel<FBStorage<FBAchievement>>, imageModel: ImageModel, user: User) {
        self.user = user
        self.achievementModel = achievementModel
        self.imageModel = imageModel
        let userAchievements = user.achievements
        achievementModel.$achievements.map { achievements in
            achievements.filter({ userAchievements.contains($0.id ?? "") }).map { achievement in
                AchievementItemViewModel(
                    achievement: achievement,
                    achievementModel: achievementModel,
                    imageModel: imageModel
                )
            }
        }
        .assign(to: \.achievementItemViewModels, on: self)
        .store(in: &cancellables)
    }
}
