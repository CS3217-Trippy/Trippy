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

    init(session: SessionStore) {
        self.session = session
        guard let user = session.session else {
            self.email = ""
            self.username = ""
            return
        }
        self.email = user.email
        self.username = user.username
    }

    func updateUserData() {
        guard let oldUser = session.session else {
            fatalError("User should have logged in")
        }
        oldUser.username = username
        session.updateUser(updatedUser: oldUser)
    }

    func deleteUser() {
        session.deleteUser()
    }
}
