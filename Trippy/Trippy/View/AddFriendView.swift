//
//  AddFriendView.swift
//  Trippy
//
//  Created by Fidella Widjojo on 19/03/21.
//

import SwiftUI

struct AddFriendView: View {
    @State var username: String = ""
    @EnvironmentObject var session: SessionStore
    @ObservedObject var viewModel: AddFriendViewModel
    var body: some View {
        VStack {
            HStack {
                TextField("Enter username...", text: $username)
                Button("Search") {
                    viewModel.getUsers()

                }
            }
            List(viewModel.usersList.filter {
                    $0.id != session.session?.id &&
                        !(session.session?.friendsId.contains($0.id) ?? false) && $0.username.contains(username)
            }) { user in
                    HStack {
                        CircleImageView()
                        Spacer()
                        Text(user.username)
                        Spacer()
                        Button(action: {
                            if let curUser = session.session {
                                viewModel.addFriend(curUser: curUser, user: user) }}) {
                            Text("Add")
                                .foregroundColor(.blue)
                        }
                    }
            }
        }
    }
}
