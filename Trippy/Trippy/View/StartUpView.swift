//
//  StartUpView.swift
//  Trippy
//
//  Created by Audrey Felicio Anwar on 15/3/21.
//

import SwiftUI

struct StartUpView: View {
    @EnvironmentObject var session: SessionStore

    var body: some View {
        NavigationView {
            VStack(spacing: 10) {
                Text("Trippy")
                    .font(.largeTitle)
                NavigationLink(destination: LogInView(logInViewModel: LogInViewModel(session: session))) {
                    Text("LOG IN")
                }
                NavigationLink(destination: SignUpView(signUpViewModel: SignUpViewModel(session: session))) {
                    Text("SIGN UP")
                }
            }
            .padding()
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct StartUpView_Previews: PreviewProvider {
    static var previews: some View {
        StartUpView()
    }
}
