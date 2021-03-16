//
//  AccountPageView.swift
//  Trippy
//
//  Created by Audrey Felicio Anwar on 17/3/21.
//

import SwiftUI

struct AccountPageView: View {
    @EnvironmentObject var session: SessionStore
    @ObservedObject var accountPageViewModel: AccountPageViewModel

    var body: some View {
        if let user = session.session {
            VStack(spacing: 10) {
                CircleImageView()
                Text("\(user.username)")
                    .bold()
                    .font(.headline)
                VStack {
                    Text("USERNAME")
                    TextField("Enter new username", text: $accountPageViewModel.username)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                VStack {
                    Text("EMAIL")
                    Text(accountPageViewModel.email)
                }
                Button("UPDATE ACCOUNT") {
                    accountPageViewModel.updateUserData()
                }
            }
            .padding()
        }
    }
}

struct AccountPageView_Previews: PreviewProvider {
    static func setUser() -> SessionStore {
        let sessionStore = SessionStore()
        sessionStore.session = User(
            id: "1", email: "1", username: "CAT", followersId: [], followingId: [])
        return sessionStore
    }

    static var previews: some View {
        AccountPageView(accountPageViewModel: AccountPageViewModel(session: setUser()))
            .environmentObject(setUser())
    }
}
