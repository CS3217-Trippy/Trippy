//
//  AccountPageView.swift
//  Trippy
//
//  Created by Audrey Felicio Anwar on 17/3/21.
//

import SwiftUI

struct AccountPageView: View {
    @EnvironmentObject var session: FBSessionStore
    @ObservedObject var accountPageViewModel: AccountPageViewModel
    var user: User

    var body: some View {
        VStack(spacing: 10) {
            CircleImageView()
            Text("\(user.username)")
                .bold()
                .font(.title)
            Text(accountPageViewModel.email)
                .font(.headline)
            Spacer().frame(height: 25)
            LevelProgressionView(viewModel: LevelProgressionViewModel(session: session))
            Spacer().frame(height: 25)
            VStack {
                Text("CHANGE USERNAME")
                TextField("Enter new username", text: $accountPageViewModel.username)
                    .frame(width: 400, height: nil, alignment: .center)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            Spacer().frame(height: 25)
            VStack(spacing: 10) {
                Button("UPDATE ACCOUNT") {
                    accountPageViewModel.updateUserData()
                }
                Button("DELETE ACCOUNT") {
                    accountPageViewModel.deleteUser()
                }.foregroundColor(.red)
                Text(accountPageViewModel.errorMessage)
                    .foregroundColor(.red)
            }
        }
        .padding()
    }
}

struct AccountPageView_Previews: PreviewProvider {
    static func setSession() -> FBSessionStore {
        let sessionStore = FBSessionStore()
        var userArray = [User]()
        userArray.append(User(id: "1", email: "1", username: "CAT", friendsId: [], levelSystemId: "1"))
        sessionStore.session = userArray
        return sessionStore
    }

    static func setUser() -> User {
        User(
            id: "1",
            email: "1",
            username: "CAT",
            friendsId: [],
            levelSystemId: "1"
        )
    }

    static var previews: some View {
        AccountPageView(
            accountPageViewModel: AccountPageViewModel(session: setSession()),
            user: setUser())
            .environmentObject(setSession())
    }
}
