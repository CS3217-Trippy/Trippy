//
//  Achievement.swift
//  Trippy
//
//  Created by Audrey Felicio Anwar on 10/4/21.
//

/// A class describing achievement
class Achievement: Model {
    var id: String?
    var name: String
    var description: String
    var imageId: String?
    var achievementType: AchievementType
    var exp: Int

    init(
        id: String?,
        name: String,
        description: String,
        achievementType: AchievementType,
        exp: Int,
        imageId: String?
    ) {
        self.id = id
        self.name = name
        self.description = description
        self.achievementType = achievementType
        self.exp = exp
        self.imageId = imageId
    }
}
