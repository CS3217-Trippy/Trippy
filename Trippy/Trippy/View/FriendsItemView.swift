//
//  FriendsItemView.swift
//  Trippy
//
//  Created by Fidella Widjojo on 16/03/21.
//

import SwiftUI

struct FriendsItemView: View {
    @EnvironmentObject var session: SessionStore
    @ObservedObject var friendsItemViewModel: FriendsItemViewModel

    var body: some View {
        RectangularCard(
            width: UIScreen.main.bounds.width - 10,
            height: 210,
            viewBuilder: { HStack {
                Image("cat")
                    .resizable()
                    .frame(width: 150, height: 150, alignment: .center)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.white, lineWidth: 4))
                    .shadow(radius: 7)
                Spacer()
                Text(friendsItemViewModel.user.username)
                Spacer()
                Button(action: {
                        friendsItemViewModel.deleteFriend(session: session) }) {
                    Text("Delete")
                        .foregroundColor(.blue)
                }
            }
            }
        )
    }
}
