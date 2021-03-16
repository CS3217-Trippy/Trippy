//
//  LoginViewModel.swift
//  Trippy
//
//  Created by Audrey Felicio Anwar on 14/3/21.
//

import SwiftUI
import Combine

final class LoginViewModel: ObservableObject, Identifiable {
    @Published var email = ""
    @Published var password = ""

    func login(session: SessionStore) {
        session.signIn(email: email, password: password) { _, error in
            if let error = error {
                print(error)
                return
            }
            self.email = ""
            self.password = ""
        }
    }
}
