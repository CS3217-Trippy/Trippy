//
//  AddFriendView.swift
//  Trippy
//
//  Created by Fidella Widjojo on 19/03/21.
//

import SwiftUI

struct AddFriendView: View {
    @State var username: String = ""
    @EnvironmentObject var session: FBSessionStore
    @ObservedObject var viewModel: AddFriendViewModel
    @State private var showStorageError = false
    @Environment(\.presentationMode) var presentationMode

    var search: some View {
        HStack {
            TextField("Enter username...", text: $username)
            Button("Search") {
                viewModel.getUsers()
            }
        }
    }

    var listView: some View {
        List(viewModel.usersList.filter {
            $0.id != session.currentLoggedInUser?.id
                && !(session.currentLoggedInUser?.friendsId.contains($0.id ?? "") ?? false)
                && $0.username.contains(username)
        }) { user in
            HStack {
                CircleImageView(image: viewModel.image)
                Spacer()
                Text(user.username)
                Spacer()
                Button(action: {
                    if let currentUser = session.currentLoggedInUser {
                        do {
                            try viewModel.addFriend(currentUser: currentUser, user: user)
                        } catch {
                            showStorageError = true
                        }
                        if !showStorageError {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                }
                ) {
                    Text("Add")
                        .foregroundColor(.blue)
                }
            }
        }
    }

    var body: some View {
        VStack {
            search
            listView
        }.alert(isPresented: $showStorageError) {
            Alert(
                title: Text("An error occurred while attempting to add friend.")
            )
        }
    }
}
