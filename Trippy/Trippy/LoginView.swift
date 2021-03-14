//
//  LoginView.swift
//  Trippy
//
//  Created by Audrey Felicio Anwar on 14/3/21.
//

import SwiftUI

struct LoginView: View {
    @ObservedObject var loginViewModel = LoginViewModel()

    var body: some View {
        VStack {
            Text("LOGIN")
            TextField("Email", text: $loginViewModel.email)
            TextField("Password", text: $loginViewModel.password)
            Button("Login") {
                self.loginViewModel.login()
            }
        }
        .padding()
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
