//
//  MeetupItemView.swift
//  Trippy
//
//  Created by Lim Chun Yong on 13/4/21.
//

import SwiftUI

struct MeetupItemView: View {
    @ObservedObject var viewModel: MeetupItemViewModel
    @EnvironmentObject var session: FBSessionStore
    @Environment(\.presentationMode) var presentationMode
    let font = Font.body
    let showFullDetails: Bool
    let isHorizontal: Bool

    var details: some View {
        VStack {
            if showFullDetails {
                Text(viewModel.locationCategory ?? "")
                .font(.headline)
                .foregroundColor(.secondary)
            }

            Text(viewModel.locationName ?? "")
            .font(font)
            .foregroundColor(.primary)
            .lineLimit(1)

            if showFullDetails {
                Text(viewModel.dateOfMeetup)
                .font(.caption)
                .fontWeight(.black)
                .foregroundColor(.secondary)
            }
        }
    }

        var leave: some View {
            ButtonWithConfirmation(buttonName: nil, warning: nil, image: "trash") {
                do {
                    try viewModel.remove(userId: session.currentLoggedInUser?.id)
                } catch {
                    print("error while removing")
                }
            }
        }

    var join: some View {
        RaisedButton(child: "Join", colorHex: Color.buttonBlue, width: 50) {
            do {
                 try viewModel.joinMeetup(
                     userId: session.currentLoggedInUser?.id,
                     levelSystemService: session.levelSystemService
                 )
             } catch {
                 print("error while adding")
             }
        }
    }

    var textView: some View {
        VStack(alignment: .leading) {
            HStack {
                details
                Spacer()
                if showFullDetails && viewModel.userJoinedMeetup(userId: session.currentLoggedInUser?.id) {
                    leave
                }
            }
            if !viewModel.userJoinedMeetup(userId: session.currentLoggedInUser?.id) {
                join.padding(.vertical)
            }
        }
    }

    var card: some View {
        RectangularCard(
        image: viewModel.image,
        isHorizontal: isHorizontal) {
            textView.padding()
        }
    }

    var body: some View {
        NavigationLink(destination: MeetupChatView(viewModel: .init(meetupItem: viewModel.meetupItem, chatModel: viewModel.chatModel,
                                                                    location: viewModel.location,
                                                                    image: viewModel.image))) {
            card
        }
    }
}
