//
//  MeetupDetailView.swift
//  Trippy
//
//  Created by Lim Chun Yong on 13/4/21.
//

import Foundation

import SwiftUI

struct MeetupDetailView: View {
    @ObservedObject var viewModel: MeetupDetailViewModel
    @EnvironmentObject var session: FBSessionStore
    @Environment(\.presentationMode) var presentationMode

    var keyDetails: some View {
        VStack(alignment: .leading) {
            Text(viewModel.category)
            .font(.headline)
            .foregroundColor(.secondary)

            Text(viewModel.title)
            .font(.title)
            .fontWeight(.black)
            .foregroundColor(.primary)

            Text("Hosted by \(viewModel.host)")
            .font(.body)
                .foregroundColor(Color(.black))
        }
    }

    var additionalDetails: some View {
        VStack(alignment: .leading) {
            Text("About")
            .font(.title2)
            .fontWeight(.bold)
            .padding(.bottom)

            Text("Number of participants: \(viewModel.count)")
                .font(.body)
                    .foregroundColor(Color(.black))

            Text("Meetup date: \(viewModel.meetupDate)")

            Text(viewModel.description)
            .font(.body)
            .padding(.top)
            .foregroundColor(.primary)
        }
    }

    var leaveMeetup: some View {
        Text("Leave meetup").foregroundColor(.red).padding(.top).onTapGesture {
            do {
                try viewModel.remove(userId: session.currentLoggedInUser?.id)
            } catch {
                print("error while removing")
            }
            presentationMode.wrappedValue.dismiss()
        }
    }

    var joinMeetup: some View {
        RaisedButton(child: "Join Meetup", colorHex: Color.buttonBlue) {

        }
    }

    var interactions: some View {
        if viewModel.userInMeetup(user: session.currentLoggedInUser) {
            return AnyView(leaveMeetup)
        } else {
            return AnyView(joinMeetup)
        }
    }

    var pageContent: some View {
        VStack(alignment: .leading) {
            keyDetails
            Divider()
            additionalDetails
            interactions
        }
    }

    var body: some View {
        ScrollView {
            VStack {
                if let image = viewModel.image {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                } else {
                    Image("Placeholder")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                }

                HStack {
                    pageContent
                    Spacer()
                }
                .padding()
            }
        }
    }
}
