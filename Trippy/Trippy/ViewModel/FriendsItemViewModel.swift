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
    private var model: FriendsListModel<FBStorage<FBFriend>>
    var username: String {
        friend.friendUsername
    }
    var hasAccepted: Bool {
        friend.hasAccepted
    }

    init(friend: Friend, model: FriendsListModel<FBStorage<FBFriend>>) {
        self.model = model
        self.friend = friend
        fetchImage()
    }

    private func fetchImage() {
        let model = ImageModel(storage: FBImageStorage())
        if let id = friend.friendProfilePhoto {
            model.fetch(ids: [id]) { images in
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
        try model.addFriend(friend: newFriend)
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
        try model.updateFriend(friend: newFriend)
    }
}
