//
//  MeetupChatView.swift
//  Trippy
//
//  Created by Lim Chun Yong on 2/5/21.
//

import Combine
import Foundation
import SwiftUI

struct MeetupChatView: View {
    @ObservedObject var viewModel: MeetupChatViewModel
    @State var typingMessage: String = ""
    @EnvironmentObject var session: FBSessionStore
    @State var showError = false

    var topBody: some View {
        HStack {
            if let image = viewModel.image {
                Image(uiImage: image).resizable()
                    .clipShape(Circle())
                    .frame(width: 50, height: 50)
            }
            Text(viewModel.locationName).lineLimit(1)
        }
    }

    var barView: some View {
        if let detailViewModel = viewModel.detailViewModel {
            return AnyView(NavigationLink(destination: LocationDetailView(viewModel: detailViewModel)) {
                topBody
            })
        } else {
            return AnyView(topBody)
        }
    }

    var body: some View {
        VStack {
           List {
            ForEach(viewModel.messages, id: \.id) { msg in
                MessageView(currentMessage: msg)
            }
           }
           HStack {
               TextField("Message...", text: $typingMessage)
                  .textFieldStyle(RoundedBorderTextFieldStyle())
                  .frame(minHeight: CGFloat(30))
            Button("Send") {
                do {
                    try viewModel.sendMessage(message: typingMessage, user: session.currentLoggedInUser)
                    typingMessage = ""
                } catch {
                    showError = true
                }
            }
           }.frame(minHeight: CGFloat(50)).padding()
        }.alert(isPresented: $showError) {
            Alert(
                title: Text("An error occurred while attempting to send the message.")
            )
        } .navigationBarItems(leading: barView)
    }
}

struct MessageView: View {
    @EnvironmentObject var session: FBSessionStore
    @ObservedObject var currentMessage: ChatMessageViewModel
    var body: some View {
        HStack(alignment: .bottom, spacing: 15) {
            if !currentMessage.isCurrentUser(userId: session.currentLoggedInUser?.id) {
                Spacer()
            }
            ContentMessageView(contentMessage: currentMessage.message,
                               username: currentMessage.username,
                               isCurrentUser: currentMessage.isCurrentUser(userId: session.currentLoggedInUser?.id))
        }
    }

}

struct ContentMessageView: View {
    var contentMessage: String
    var username: String
    var isCurrentUser: Bool

    var body: some View {
        VStack {
            if !isCurrentUser {
                Text(username).font(.footnote)
            }
            Text(contentMessage)
                .padding(10)
                .foregroundColor(isCurrentUser ? Color.white : Color.black)
                .background(isCurrentUser ? Color.blue : Color.chatMessageBody)
                .cornerRadius(10)
        }
    }
}
