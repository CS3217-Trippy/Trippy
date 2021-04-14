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
    @State private var selectedPrivacy: String = ""
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

    var categorySelector: some View {
        Picker("Category", selection: $selectedPrivacy) {
            ForEach(viewModel.privacyOptions, id: \.self) {
                Text($0.capitalized)
            }
        }
    }

    var datePicker: some View {
        DatePicker(selection: $meetupDate, in: Date()..., displayedComponents: .date) {
            Text("Select a date")
        }
    }

    var notesInput: some View {
        TextField("Notes", text: $userDescription)
    }

    var submitSection: some View {
        Section {
            Button("Create meetup") {
                do {
                    try viewModel.saveForm(meetupDate: meetupDate,
                                           userDescription: userDescription, meetupPrivacy: selectedPrivacy,
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

    var body: some View {
        Form {
            Section {
                search
                listView
            }
            Section {
                categorySelector
                datePicker
                notesInput
            }
            submitSection
        }
}
}
