//
//  SignUpViewModel.swift
//  Trippy
//
//  Created by Audrey Felicio Anwar on 14/3/21.
//

import SwiftUI
import Combine

final class SignUpViewModel: ObservableObject, Identifiable {
    @Published var email = ""
    @Published var username = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    @Published var errorMessage = ""

    func signUp(session: SessionStore) {
        if password != confirmPassword {
            return
        }
        session.signUp(email: email, password: password, username: username) { _, error in
            if let error = error {
                self.errorMessage = error.localizedDescription
                return
            }
            self.email = ""
            self.password = ""
            self.username = ""
            self.confirmPassword = ""
            self.errorMessage = ""
        }
    }
}
