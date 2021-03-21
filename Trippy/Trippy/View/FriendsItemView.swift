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
                CircleImageView()
                Text(friendsItemViewModel.user.username)
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
