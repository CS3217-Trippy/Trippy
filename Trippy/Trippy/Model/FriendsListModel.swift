//
//  FriendsListModel.swift
//  Trippy
//
//  Created by Fidella Widjojo on 16/03/21.
//

import Foundation
import Combine

final class FriendsListModel {
    @Published var friendsList: [User] = []
    private var cancellables: Set<AnyCancellable> = []
    var storage: UserStorage
    var user: User?

    init(session: SessionStore) {
        storage = session.userStorage
        user = session.session
        storage.friendsList.assign(to: \.friendsList, on: self).store(in: &cancellables)
    }

    func getFriendsList() {
        if let user = self.user {
            self.storage.getFriendsList(user: user)
        }
    }
}
