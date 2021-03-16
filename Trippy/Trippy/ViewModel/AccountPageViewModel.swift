//
//  AccountPageViewModel.swift
//  Trippy
//
//  Created by Audrey Felicio Anwar on 17/3/21.
//

import SwiftUI
import Combine

final class AccountPageViewModel: ObservableObject, Identifiable {
    @Published var email = ""
    @Published var username = ""
    private var session: SessionStore
    private var userStorage: UserStorage

    init(session: SessionStore) {
        self.session = session
        self.userStorage = session.userStorage
        guard let user = session.session else {
            fatalError("User should have logged in")
        }
        self.email = user.email
        self.username = user.username
    }

    func updateUserData() {
        guard let oldUser = session.session else {
            fatalError("User should have logged in")
        }
        oldUser.username = username
        userStorage.updateUserData(user: oldUser)
    }
}
