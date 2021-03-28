//
//  FriendsListModel.swift
//  Trippy
//
//  Created by Fidella Widjojo on 16/03/21.
//

import Foundation
import Combine

final class FriendsListModel<Storage: UserRelatedStorage> where Storage.StoredType == Friend {
    @Published var friendsList: [Friend] = []
    private var cancellables: Set<AnyCancellable> = []
    var storage: Storage
    var userId: String?

    init(storage: Storage, userId: String?) {
        self.storage = storage
        self.userId = userId
        storage.storedItems.assign(to: \.friendsList, on: self).store(in: &cancellables)
        getFriendsList()
    }

    func getFriendsList() {
        storage.fetch()
    }

    func addFriend(friend: Friend) throws {
        try storage.add(item: friend)
    }

    func updateFriend(friend: Friend) throws {
        guard friendsList.contains(where: { $0.id == friend.id }) else {
            return
        }
        try storage.update(item: friend)
    }

    func removeFriend(friend: Friend) {
        guard friendsList.contains(where: { $0.id == friend.id }) else {
            return
        }
        storage.remove(item: friend)
    }
}
