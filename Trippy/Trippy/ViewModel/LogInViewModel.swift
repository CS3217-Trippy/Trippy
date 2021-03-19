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

    func login(session: SessionStore) {
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
