//
//  FBUser.swift
//  Trippy
//
//  Created by Audrey Felicio Anwar on 28/3/21.
//

import Foundation

/// Represents a user specific to firebase storage solution
struct FBUser: FBStorable {
    typealias ModelType = User
    static var path = "users"
    var id: String?
    var imageIds: [String] = []
    var email: String
    var username: String
    var achievements: [String]
    var levelSystemId: String

    init(item: ModelType) {
        id = item.id
        email = item.email
        username = item.username
        levelSystemId = item.levelSystemId
        achievements = item.achievements
        if let id = item.imageId {
            imageIds.append(id)
        }
    }

    /// Converts from storage specific to general model
    func convertToModelType() -> User {
        var imageId: String?
        if !imageIds.isEmpty {
            imageId = imageIds[0]
        }
        let user = User(
            id: id,
            email: email,
            username: username,
            levelSystemId: levelSystemId,
            achievements: achievements,
            imageId: imageId
        )
        return user
    }
}
