//
//  AccountPageView.swift
//  Trippy
//
//  Created by Audrey Felicio Anwar on 17/3/21.
//

import SwiftUI

struct AccountPageView: View {
    @ObservedObject var accountPageViewModel: AccountPageViewModel
    var user: User

    var body: some View {
        VStack(spacing: 10) {
            CircleImageView()
            Text("\(user.username)")
                .bold()
                .font(.headline)
            VStack {
                Text("USERNAME")
                TextField("Enter new username", text: $accountPageViewModel.username)
                    .frame(width: 400, height: nil, alignment: .center)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            VStack {
                Text("EMAIL")
                Text(accountPageViewModel.email)
            }
            Button("UPDATE ACCOUNT") {
                accountPageViewModel.updateUserData()
            }
            Button("DELETE ACCOUNT") {
                accountPageViewModel.deleteUser()
            }.foregroundColor(.red)
        }
        .padding()
    }
}

struct AccountPageView_Previews: PreviewProvider {
    static func setSession() -> SessionStore {
        let sessionStore = SessionStore()
        sessionStore.session = User(
            id: "1", email: "1", username: "CAT", friendsId: [])
        return sessionStore
    }

    static func setUser() -> User {
        User(
            id: "1", email: "1", username: "CAT", friendsId: [])
    }

    static var previews: some View {
        AccountPageView(accountPageViewModel: AccountPageViewModel(session: setSession()), user: setUser())
    }
}
