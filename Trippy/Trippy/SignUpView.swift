//
//  SignUpView.swift
//  Trippy
//
//  Created by Audrey Felicio Anwar on 14/3/21.
//

import SwiftUI

struct SignUpView: View {
    @ObservedObject var signUpViewModel = SignUpViewModel()

    var body: some View {
        VStack {
            Text("CREATE ACCOUNT")
            TextField("Email", text: $signUpViewModel.email)
            TextField("Username", text: $signUpViewModel.username)
            SecureField("Password", text: $signUpViewModel.password)
            SecureField("Confirm Password", text: $signUpViewModel.confirmPassword)
            Button("Sign Up") {
                self.signUpViewModel.signUp()
            }
        }
        .padding()
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
