//
//  FBAchievement.swift
//  Trippy
//
//  Created by Audrey Felicio Anwar on 10/4/21.
//

import UIKit
import FirebaseFirestoreSwift

struct FBAchievement: FBImageSupportedStorable {
    typealias ModelType = Achievement
    static var path = "achievements"

    @DocumentID var id: String?
    var name: String
    var description: String
    var imageURL: [String] = []
    var type: String
    var completion: Int

    init(item: ModelType) {
        self.id = item.id
        self.name = item.name
        self.description = item.description
        self.completion = item.achievementType.getCompletion()
        self.type = item.achievementType.getTypeDescription()
    }

    func convertToModelType() -> ModelType {
        let achievement = Achievement(
            id: id,
            name: name,
            description: description,
            achievementType: AchievementType.generateAchievementType(type: type, completion: completion)
        )

        if !imageURL.isEmpty {
            let url = imageURL[0]
            Downloader.getDataFromString(from: url) { data, _, error in
                guard let data = data, error == nil else {
                    return
                }
                DispatchQueue.main.async {
                    let image = UIImage(data: data)
                    achievement.imageURL = image
                }
            }
        }

        return achievement
    }
}
