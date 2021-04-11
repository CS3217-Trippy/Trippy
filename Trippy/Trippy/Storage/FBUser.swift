//
//  FBUser.swift
//  Trippy
//
//  Created by Audrey Felicio Anwar on 28/3/21.
//

import Foundation
import UIKit

struct FBUser: FBStorable {
    typealias ModelType = User
    static var path = "users"
    var id: String?
    var imageIds: [String] = []
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
        if let id = item.imageId {
            imageIds.append(id)
        }
    }

    func convertToModelType() -> User {
        var imageId: String?
        if !imageIds.isEmpty {
            imageId = imageIds[0]
        }
        let user = User(
            id: id,
            email: email,
            username: username,
            friendsId: friendsId,
            levelSystemId: levelSystemId,
            imageId: imageId
        )
        return user
    }
}
