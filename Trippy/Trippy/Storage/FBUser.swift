//
//  FBUser.swift
//  Trippy
//
//  Created by Audrey Felicio Anwar on 28/3/21.
//

import Foundation

struct FBUser: FBImageSupportedStorable {
    typealias ModelType = User
    static var path = "users"
    var imageURL: String?
    var id: String?
    var email: String
    var username: String
    var friendsId: [String]

    init(item: ModelType) {
        id = item.id
        email = item.email
        username = item.username
        friendsId = item.friendsId
    }

    func convertToModelType() -> User {
        return User(
            id: id,
            email: email,
            username: username,
            friendsId: friendsId
        )
    }
}
