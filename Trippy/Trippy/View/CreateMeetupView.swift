//
//  CreateMeetupView.swift
//  Trippy
//
//  Created by Lim Chun Yong on 13/4/21.
//

import SwiftUI

struct CreateMeetupView: View {
    @ObservedObject var viewModel: CreateMeetupViewModel
    @EnvironmentObject var session: FBSessionStore
    @State var username: String = ""
    @State private var userDescription: String = ""
    @State private var showStorageError = false
    @State private var friendsSelected: [Friend] = []
    @State private var meetupDate = Date()
    @Environment(\.presentationMode) var presentationMode

    var search: some View {
        HStack {
            TextField("Enter username...", text: $username)
        }
    }

    var listView: some View {
        List(viewModel.friendsList.filter {
            $0.friendUsername.contains(username) || username.isEmpty
        }) { friend in
            HStack {
                Button(action: {
                    if friendsSelected.contains(where: { $0.friendId == friend.friendId }) {
                        friendsSelected.removeAll { $0.friendId == friend.friendId }
                    } else {
                        friendsSelected.append(friend)
                    }
                }
                ) {
                    Image(systemName:
                            friendsSelected.contains { $0.friendId == friend.friendId } ?
                            "checkmark.square": "square").padding(10)
                }
                CircleImageView(image: viewModel.images[friend.friendProfilePhoto, default: nil])
                Spacer()
                Text(friend.friendUsername)
                Spacer()
            }
        }
    }

    var body: some View {
        Form {
            search
            listView
            TextField("Notes", text: $userDescription)
            DatePicker(selection: $meetupDate, in: Date()..., displayedComponents: .date) {
                Text("Select a date")
            }
            Button("Create meetup") {
                do {
                    try viewModel.saveForm(meetupDate: meetupDate,
                                           userDescription: userDescription,
                                           friends: friendsSelected)
                } catch {
                    showStorageError = true
                }
                if !showStorageError {
                    presentationMode.wrappedValue.dismiss()
                }
            }.alert(isPresented: $showStorageError) {
                Alert(
                    title: Text("An error occurred while attempting to save the information.")
                )
            }
        }.navigationBarTitle("Create meetup")
    }
}
