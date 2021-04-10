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

    init(item: ModelType) {
        self.id = item.id
        self.name = item.name
        self.description = item.description
    }

    func convertToModelType() -> ModelType {
        let achievement = Achievement(
            id: id,
            name: name,
            description: description
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
