//
//  LevelProgressionViewModel.swift
//  Trippy
//
//  Created by Audrey Felicio Anwar on 31/3/21.
//

import SwiftUI
import Combine

final class LevelProgressionViewModel: ObservableObject, Identifiable {
    @Published var level = 1
    @Published var experience = 0
    @Published var experienceToNextLevel = 100
    @Published var percentageToNextLevel = 0.0
    private var session: SessionStore

    init(session: SessionStore) {
        self.session = session
        self.level = 1
        self.experience = 0
        self.experienceToNextLevel = 100
        self.percentageToNextLevel = 0.0
//        guard let userLevelSystemService = session.levelSystemService else {
//            self.level = 1
//            self.experience = 0
//            self.experienceToNextLevel = 100
//            self.percentageToNextLevel = 0.0
//            return
//        }
//        let userLevelSystem = userLevelSystemService.getUserLevelSystem()
//        (self.experienceToNextLevel, self.percentageToNextLevel) =
//            userLevelSystemService.generateExperienceProgressData()
//        self.level = userLevelSystem.level
//        self.experience = userLevelSystem.experience
    }
}
