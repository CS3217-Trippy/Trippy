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
        getFriendsList()
    }

    func getFriendsList() {
        let field = "userId"
        guard let id = userId else {
            return
        }
        storage.fetchWithField(field: field, value: id, handler: nil)
    }

    func addFriend(friend: Friend) throws {
        try storage.add(item: friend, handler: nil)
    }

    func updateFriend(friend: Friend) throws {
        guard friendsList.contains(where: { $0.id == friend.id }) else {
            return
        }
        try storage.update(item: friend, handler: nil)
    }

    func removeFriend(friend: Friend) {
        guard friendsList.contains(where: { $0.id == friend.id }) else {
            return
        }
        storage.remove(item: friend)
    }
}
