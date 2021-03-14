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

    func signUp() {
        if password == confirmPassword {
            print("Success!")
        }
    }
}
