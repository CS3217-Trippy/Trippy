//
//  LoginViewModel.swift
//  Trippy
//
//  Created by Audrey Felicio Anwar on 14/3/21.
//

import SwiftUI
import Combine

final class LogInViewModel: ObservableObject, Identifiable {
    @Published var email = ""
    @Published var password = ""
    @Published var errorMessage = ""
    private var session: SessionStore

    init(session: SessionStore) {
        self.session = session
    }

    func login() {
        session.logIn(email: email, password: password) { _, error in
            if let error = error {
                self.errorMessage = error.localizedDescription
                return
            }
            self.email = ""
            self.password = ""
            self.errorMessage = ""
        }
    }
}
