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

    func login() {
        print(email,  password)
    }
}
