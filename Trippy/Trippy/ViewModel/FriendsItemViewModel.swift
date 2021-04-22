//
//  FriendsItemViewModel.swift
//  Trippy
//
//  Created by Fidella Widjojo on 16/03/21.
//

import Foundation
import UIKit

final class FriendsItemViewModel: ObservableObject, Identifiable {
    @Published var friend: Friend
    @Published var friendProfilePhoto: UIImage?
    private var friendsModel: FriendsListModel<FBStorage<FBFriend>>
    private var userModel = UserModel(storage: FBStorage<FBUser>())
    private var imageModel: ImageModel
    @Published var username: String = ""
    @Published var hasAccepted: Bool
    @Published var hasFriendAccepted: Bool = false

    init(friend: Friend, model: FriendsListModel<FBStorage<FBFriend>>, imageModel: ImageModel) {
        self.friendsModel = model
        self.imageModel = imageModel
        self.friend = friend
        self.hasAccepted = friend.hasAccepted
        userModel.fetchUsers(handler: fetchFriend)
    }

    private func fetchFriend(users: [User]) {
        guard let friendData = users.first(where: { $0.id == friend.friendId }) else {
            return
        }
        if let id = friendData.imageId {
            imageModel.fetch(ids: [id]) { images in
                if !images.isEmpty {
                    self.friendProfilePhoto = images[0]
                }
            }
        }
        username = friendData.username
        self.hasFriendAccepted = friendsModel.friendsList.first(
            where: { $0.userId == friend.friendId && $0.friendId == friend.userId })?.hasAccepted ?? false
    }

    func acceptFriend() throws {
        if friend.hasAccepted {
            return
        }
        try friendsModel.acceptFriendRequest(friendId: friend.friendId)
    }

    func deleteFriend() {
        friendsModel.deleteFriends(friendId: friend.friendId)
    }

}
