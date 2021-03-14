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

    func signUp(session: SessionStore) {
        if password != confirmPassword {
            return
        }
        session.signUp(email: email, password: password) { (result, error) in
            if let error = error {
                print(error)
                return
            }
            self.email = ""
            self.password = ""
            self.username = ""
            self.confirmPassword = ""
        }
    }
}
