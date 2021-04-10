//
//  FBUser.swift
//  Trippy
//
//  Created by Audrey Felicio Anwar on 28/3/21.
//

import Foundation
import UIKit

struct FBUser: FBImageSupportedStorable {
    typealias ModelType = User
    static var path = "users"
    var id: String?
    var imageURL: [String] = []
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
    }

    func convertToModelType() -> User {
        let user = User(
            id: id,
            email: email,
            username: username,
            friendsId: friendsId,
            levelSystemId: levelSystemId
        )

        if !imageURL.isEmpty {
            let url = imageURL[0]
            Downloader.getDataFromString(from: url) { data, _, error in
                guard let data = data, error == nil else {
                    return
                }
                DispatchQueue.main.async {
                    let image = UIImage(data: data)
                    user.imageURL = image
                }
            }
        }
        return user
    }
}
