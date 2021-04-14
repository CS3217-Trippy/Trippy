//
//  FBAchievement.swift
//  Trippy
//
//  Created by Audrey Felicio Anwar on 10/4/21.
//

import UIKit
import FirebaseFirestoreSwift

struct FBAchievement: FBStorable {
    typealias ModelType = Achievement
    static var path = "achievements"

    @DocumentID var id: String?
    var name: String
    var description: String
    var imageIds: [String] = []
    var type: String
    var completion: Int
    var exp: Int

    init(item: ModelType) {
        self.id = item.id
        self.name = item.name
        self.description = item.description
        self.completion = item.achievementType.getCompletion()
        self.type = item.achievementType.getTypeDescription()
        self.exp = item.exp
        if let id = item.imageId {
            imageIds.append(id)
        }
    }

    func convertToModelType() -> ModelType {
        var imageId: String?
        if !imageIds.isEmpty {
            imageId = imageIds[0]
        }
        let achievement = Achievement(
            id: id,
            name: name,
            description: description,
            achievementType: AchievementType.generateAchievementType(type: type, completion: completion),
            exp: exp,
            imageId: imageId
        )

        return achievement
    }
}
