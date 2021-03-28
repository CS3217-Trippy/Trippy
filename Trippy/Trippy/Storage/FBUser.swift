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
    var id: String?
    var imageURL: String?
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
        User(
            id: id,
            email: email,
            username: username,
            friendsId: friendsId
        )
    }
}
