//
//  SignUpView.swift
//  Trippy
//
//  Created by Audrey Felicio Anwar on 14/3/21.
//

import SwiftUI

struct SignUpView: View {
    @ObservedObject var signUpViewModel: SignUpViewModel
    @EnvironmentObject var session: FBSessionStore

    var body: some View {
        VStack(spacing: 10) {
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
            RaisedButton(child: "SIGN UP", colorHex: Color.buttonBlue) {
                self.signUpViewModel.signUp()
            }.cornerRadius(10)
            Text(signUpViewModel.errorMessage)
                .foregroundColor(.red)
        .padding()
        .textFieldStyle(RoundedBorderTextFieldStyle())
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView(signUpViewModel: SignUpViewModel(session: FBSessionStore()))
    }
}
