//
//  FBAchievement.swift
//  Trippy
//
//  Created by Audrey Felicio Anwar on 10/4/21.
//

import FirebaseFirestoreSwift
import Foundation

struct FBAchievement: FBImageSupportedStorable {
    typealias ModelType = Achievement
    static var path = "achievements"

    @DocumentID var id: String?
    var name: String
    var description: String
    var imageURL: String?

    init(item: ModelType) {
        let imageURL = item.imageURL?.absoluteString
        self.id = item.id
        self.name = item.name
        self.description = item.description
        self.imageURL = imageURL
    }

    func convertToModelType() -> ModelType {
        var targetURL: URL?
        if let url = imageURL {
            targetURL = URL(string: url)
        }
        return Achievement(
            id: id,
            name: name,
            description: description,
            imageURL: targetURL
        )
    }
}
