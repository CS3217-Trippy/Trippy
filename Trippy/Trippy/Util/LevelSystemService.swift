//
//  LevelSystemService.swift
//  Trippy
//
//  Created by Audrey Felicio Anwar on 30/3/21.
//

import Foundation

protocol LevelSystemService {
    func createLevelSystem()

    func getUserLevelSystem() -> LevelSystem

    func retrieveLevelSystem()

    func updateLevelSystem()

    func addExperience(action: ExperienceAction)
}
