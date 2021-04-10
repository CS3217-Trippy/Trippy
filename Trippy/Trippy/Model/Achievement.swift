//
//  Achievement.swift
//  Trippy
//
//  Created by Audrey Felicio Anwar on 10/4/21.
//

import UIKit

class Achievement: Model {
    var id: String?
    var name: String
    var description: String
    var imageURL: UIImage?
    var achievementType: AchievementType

    init(id: String?, name: String, description: String, achievementType: AchievementType, imageURL: UIImage? = nil) {
        self.id = id
        self.name = name
        self.description = description
        self.achievementType = achievementType
        self.imageURL = imageURL
    }
}
