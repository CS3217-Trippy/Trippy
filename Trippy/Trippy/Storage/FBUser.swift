//
//  FBUser.swift
//  Trippy
//
//  Created by Audrey Felicio Anwar on 28/3/21.
//

import Foundation

final class FBUser: FBImageSupportedStorable {
    typealias ModelType = User
    static var path = "users"
    var id: String?
    var imageURL: String?
    var email: String
    var username: String
    var friendsId: [String]
    var levelSystemId: String

    init(item: ModelType) {
        id = item.id
        email = item.email
        username = item.username
        friendsId = item.friendsId
        levelSystemId = item.levelSystemId
        imageURL = item.imageURL?.absoluteString
    }

    func adddURLToObject(images: [String]) {
        guard !images.isEmpty else {
            return
        }
        self.imageURL = images[0]
    }

    func convertToModelType() -> User {
        var targetURL: URL?
        if let url = imageURL {
            targetURL = URL(string: url)
        }
        return User(
            id: id,
            email: email,
            username: username,
            friendsId: friendsId,
            levelSystemId: levelSystemId,
            imageURL: targetURL
        )
    }
}
