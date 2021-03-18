//
//  SignUpView.swift
//  Trippy
//
//  Created by Audrey Felicio Anwar on 14/3/21.
//

import SwiftUI

struct SignUpView: View {
    @ObservedObject var signUpViewModel = SignUpViewModel()
    @EnvironmentObject var session: SessionStore

    var body: some View {
        VStack {
            Text("CREATE ACCOUNT")
                .font(.title)
            TextField("EMAIL", text: $signUpViewModel.email)
                .frame(width: 400, height: nil, alignment: .center)
            TextField("USERNAME", text: $signUpViewModel.username)
                .frame(width: 400, height: nil, alignment: .center)
            SecureField("PASSWORD", text: $signUpViewModel.password)
                .frame(width: 400, height: nil, alignment: .center)
            SecureField("CONFIRM PASSSWORD", text: $signUpViewModel.confirmPassword)
                .frame(width: 400, height: nil, alignment: .center)
            Button("SIGN UP") {
                self.signUpViewModel.signUp(session: session)
            }
        }
        .padding()
        .textFieldStyle(RoundedBorderTextFieldStyle())
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
