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
                .font(.title)
            TextField("EMAIL", text: $logInViewModel.email)
                .frame(width: 400, height: nil, alignment: .center)
            SecureField("PASSWORD", text: $logInViewModel.password)
                .frame(width: 400, height: nil, alignment: .center)
            Button("LOGIN") {
                self.logInViewModel.login(session: session)
            }
        }
        .padding()
        .textFieldStyle(RoundedBorderTextFieldStyle())
    }
}

struct LogInView_Previews: PreviewProvider {
    static var previews: some View {
        LogInView()
    }
}
