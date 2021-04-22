//
//  FriendsListModel.swift
//  Trippy
//
//  Created by Fidella Widjojo on 16/03/21.
//

import Foundation
import Combine

final class FriendsListModel<Storage: StorageProtocol> where Storage.StoredType == Friend {
    @Published var friendsList: [Friend] = []
    private var cancellables: Set<AnyCancellable> = []
    var storage: Storage
    var userId: String?

    init(storage: Storage, userId: String?) {
        self.storage = storage
        self.userId = userId
        storage.storedItems.assign(to: \.friendsList, on: self).store(in: &cancellables)
        getFriendsList(handler: nil)
    }

    func getFriendsList(handler: (([Friend]) -> Void)?) {
        storage.fetch(handler: handler)
    }

    func addFriend(friend: Friend) throws {
        try storage.add(item: friend, handler: nil)
    }

    func updateFriend(friend: Friend) throws {
        try storage.update(item: friend, handler: nil)
    }

    func removeFriend(friend: Friend) {
        storage.remove(item: friend)
    }

    func acceptFriendRequest(friendId: String) throws {
        guard let userId = self.userId else {
            return
        }

        if let friendItem = friendsList.first(where: { $0.userId == userId && $0.friendId == friendId }) {
            friendItem.accept()
            try updateFriend(friend: friendItem)
        }

    }

    func deleteFriends(friendId: String) {
        guard let userId = self.userId else {
            return
        }

        if let friendItem = friendsList.first(where: { $0.userId == userId && $0.friendId == friendId }) {
            friendItem.accept()
            removeFriend(friend: friendItem)
        }

        if let friendItem = friendsList.first(where: { $0.userId == friendId && $0.friendId == userId }) {
            friendItem.accept()
            removeFriend(friend: friendItem)
        }
    }
}
