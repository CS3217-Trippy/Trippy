//
//  StartUpView.swift
//  Trippy
//
//  Created by Audrey Felicio Anwar on 15/3/21.
//

import SwiftUI

struct StartUpView: View {
    @EnvironmentObject var session: FBSessionStore
    @ObservedObject var logInViewModel: LogInViewModel

    var welcomeMessage: some View {
        VStack(alignment: .center) {
            Image("travel").padding()
            Text("Hello.").bold().font(.title)
            Text("Welcome Back").bold().font(.title)
        }
    }

    var body: some View {
        NavigationView {
            VStack(alignment: .center) {
                welcomeMessage
                TextField("EMAIL", text: $logInViewModel.email)
                    .frame(width: 400, height: 50, alignment: .center)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .cornerRadius(20)
                SecureField("PASSWORD", text: $logInViewModel.password)
                    .frame(width: 400, height: 50, alignment: .center)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Text(logInViewModel.errorMessage)
                    .foregroundColor(.red)
                RaisedButton(child: "LOGIN", colorHex: "287bf7") {
                    self.logInViewModel.login()
                }.cornerRadius(10)
                Text("")
                NavigationLink(destination: SignUpView(signUpViewModel: SignUpViewModel(session: session))) {
                    RaisedNavigationText(text: "SIGN UP", colorHex: "287bf7").cornerRadius(10)
                }
            }
            .padding()
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct StartUpView_Previews: PreviewProvider {
    static var previews: some View {
        StartUpView(logInViewModel: LogInViewModel(session: FBSessionStore()))
            .environmentObject(FBSessionStore())
    }
}
