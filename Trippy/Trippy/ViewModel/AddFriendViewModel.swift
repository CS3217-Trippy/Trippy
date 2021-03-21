//
//  AddFriendViewModel.swift
//  Trippy
//
//  Created by Fidella Widjojo on 19/03/21.
//

import Foundation
import Combine

final class AddFriendViewModel: ObservableObject {
    @Published var usersList: [User] = []
    private var cancellables: Set<AnyCancellable> = []
    private var userStorage: UserStorage

    init(session: SessionStore) {
        userStorage = session.userStorage
        userStorage.$usersList.assign(to: \.usersList, on: self).store(in: &cancellables)
    }

    func getUsers( ) {
        userStorage.getUsers()
    }

    func addFriend(curUser: User, user: User) {
        userStorage.addFriend(curUser: curUser, user: user)
    }
}
