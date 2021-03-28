//
//  FriendsItemViewModel.swift
//  Trippy
//
//  Created by Fidella Widjojo on 16/03/21.
//

import Foundation

final class FriendsItemViewModel: ObservableObject, Identifiable {
    @Published var user: User

    init(user: User) {
        self.user = user
    }

    func deleteFriend(session: SessionStore) {
//        if let currentUser = session.session {
//            session.userStorage.deleteFriend(currentUser: currentUser, user: user)
//        }
    }
}
