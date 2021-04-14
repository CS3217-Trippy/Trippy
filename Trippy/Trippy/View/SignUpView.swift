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
<<<<<<< Updated upstream
        VStack (spacing: 10) {
=======
<<<<<<< Updated upstream
        VStack {
=======
        VStack(spacing: 10) {
>>>>>>> Stashed changes
>>>>>>> Stashed changes
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
<<<<<<< Updated upstream
            RaisedButton(child: "SIGN UP", colorHex: "287bf7") {
=======
<<<<<<< Updated upstream
            Button("SIGN UP") {
=======
            RaisedButton(child: "SIGN UP", colorHex: Color.buttonBlue) {
>>>>>>> Stashed changes
>>>>>>> Stashed changes
                self.signUpViewModel.signUp()
            }.cornerRadius(10)
            Text(signUpViewModel.errorMessage)
                .foregroundColor(.red)
        }
        .padding()
        .textFieldStyle(RoundedBorderTextFieldStyle())
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView(signUpViewModel: SignUpViewModel(session: FBSessionStore()))
    }
}
