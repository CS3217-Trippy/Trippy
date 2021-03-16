//
//  LoginView.swift
//  Trippy
//
//  Created by Audrey Felicio Anwar on 14/3/21.
//

import SwiftUI

struct LogInView: View {
    @ObservedObject var logInViewModel = LogInViewModel()
    @EnvironmentObject var session: SessionStore

    var body: some View {
        VStack {
            Text("LOGIN")
            TextField("Email", text: $logInViewModel.email)
            SecureField("Password", text: $logInViewModel.password)
            Button("Login") {
                self.logInViewModel.login(session: session)
            }
        }
        .padding()
    }
}

struct LogInView_Previews: PreviewProvider {
    static var previews: some View {
        LogInView()
    }
}
