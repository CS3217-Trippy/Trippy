//
//  AchievementListViewModel.swift
//  Trippy
//
//  Created by Audrey Felicio Anwar on 13/4/21.
//

import Combine

final class AchievementListViewModel: ObservableObject {
    private var achievementModel: AchievementModel<FBStorage<FBAchievement>>
    @Published var achievementItemViewModels: [AchievementItemViewModel] = []
    private let imageModel: ImageModel
    private var cancellables: Set<AnyCancellable> = []

    init(achievementModel: AchievementModel<FBStorage<FBAchievement>>, imageModel: ImageModel) {
        self.achievementModel = achievementModel
        self.imageModel = imageModel
        achievementModel.$achievements.map { achievements in
            achievements.map { achievement in
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
