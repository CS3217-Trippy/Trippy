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

    func login(session: SessionStore) {
        session.logIn(email: email, password: password) { _, error in
            if let error = error {
                print(error)
                return
            }
            self.email = ""
            self.password = ""
        }
    }
}
