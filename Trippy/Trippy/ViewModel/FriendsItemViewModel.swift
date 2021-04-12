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
    private var imageModel: ImageModel
    var username: String {
        friend.friendUsername
    }
    var hasAccepted: Bool {
        friend.hasAccepted
    }

    init(friend: Friend, model: FriendsListModel<FBStorage<FBFriend>>, imageModel: ImageModel) {
        self.friendsModel = model
        self.imageModel = imageModel
        self.friend = friend
        fetchImage()
    }

    private func fetchImage() {
        if let id = friend.friendProfilePhoto {
            imageModel.fetch(ids: [id]) { images in
                if !images.isEmpty {
                    self.friendProfilePhoto = images[0]
                }
            }
        }

    }

    func acceptFriend() throws {
        if friend.hasAccepted {
            return
        }
        try buildNewFriend()
        try updateFriendToAccepted()
    }

    private func buildNewFriend() throws {
        let newFriend = Friend(
            userId: friend.friendId,
            username: friend.friendUsername,
            userProfilePhoto: friend.friendProfilePhoto,
            friendId: friend.userId,
            friendUsername: friend.username,
            friendProfilePhoto: friend.userProfilePhoto,
            hasAccepted: true
        )
        try friendsModel.addFriend(friend: newFriend)
    }

    private func updateFriendToAccepted() throws {
        let newFriend = Friend(
            userId: friend.userId,
            username: friend.username,
            userProfilePhoto: friend.userProfilePhoto,
            friendId: friend.friendId,
            friendUsername: friend.friendUsername,
            friendProfilePhoto: friend.friendProfilePhoto,
            hasAccepted: true
        )
        try friendsModel.updateFriend(friend: newFriend)
    }
}
