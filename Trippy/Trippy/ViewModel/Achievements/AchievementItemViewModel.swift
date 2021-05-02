//
//  AchievementItemViewModel.swift
//  Trippy
//
//  Created by Audrey Felicio Anwar on 13/4/21.
//

import Combine
import SwiftUI

final class AchievementItemViewModel: ObservableObject, Identifiable {
    @Published private var achievement: Achievement
    @Published var image: UIImage?
    private var achievementModel: AchievementModel<FBStorage<FBAchievement>>
    private let imageModel: ImageModel
    private var cancellables: Set<AnyCancellable> = []
    private(set) var id = ""

    var achievementName: String {
        achievement.name
    }

    var achievementDescription: String {
        achievement.description
    }

    init(
        achievement: Achievement,
        achievementModel: AchievementModel<FBStorage<FBAchievement>>,
        imageModel: ImageModel
    ) {
        self.achievement = achievement
        self.achievementModel = achievementModel
        self.imageModel = imageModel
        $achievement.compactMap { $0.id }.assign(to: \.id, on: self)
            .store(in: &cancellables)
        fetchImage()
    }

    private func fetchImage() {
        let id = achievement.imageId
        guard let imageId = id else {
            return
        }
        imageModel.fetch(ids: [imageId]) { images in
            if !images.isEmpty {
                self.image = images[0]
            }
        }
    }
}
