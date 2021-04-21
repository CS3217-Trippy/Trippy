//
//  FriendsItemView.swift
//  Trippy
//
//  Created by Fidella Widjojo on 16/03/21.
//

import SwiftUI

struct FriendsItemView: View {
    @EnvironmentObject var session: FBSessionStore
    @ObservedObject var friendsItemViewModel: FriendsItemViewModel

    var body: some View {
        let isFriendRequest = !friendsItemViewModel.hasAccepted
        RectangularCard(
            image: friendsItemViewModel.friendProfilePhoto,
            isHorizontal: true
        ) {
            HStack {
            Text(friendsItemViewModel.username).padding(10)
            Spacer()
            if isFriendRequest {
                Button(action: {
                    do {
                        try friendsItemViewModel.acceptFriend()
                        session.levelSystemService?
                            .generateExperienceFromAddingFriend(friend: friendsItemViewModel.friend)
                    } catch {
                        print(error)
                    }
                }) {
                    Text("Accept").padding(10)
                        .foregroundColor(.blue)
                }
            }
            }
        }
    }
}
