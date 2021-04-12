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
    @Published var errorMessage = ""
    @Published var selectedImage: UIImage?
    private var session: SessionStore

    init(session: SessionStore) {
        self.session = session
        guard let user = session.currentLoggedInUser else {
            self.email = ""
            self.username = ""
            return
        }
        self.email = user.email
        self.username = user.username
    }

    func updateUserData() {
        guard let oldUser = session.currentLoggedInUser else {
            fatalError("User should have logged in")
        }
        if selectedImage != nil {
            oldUser.imageId = UUID().uuidString
        }
        oldUser.username = username
        session.updateUser(updatedUser: oldUser, with: selectedImage)
    }

    func deleteUser() {
        session.deleteUser(handler: updateErrorMessage)
    }

    func updateErrorMessage(errorMessage: String) {
        self.errorMessage = errorMessage
    }
}
