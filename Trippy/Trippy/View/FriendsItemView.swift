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
        let isPendingRequest = friendsItemViewModel.hasAccepted && !friendsItemViewModel.hasFriendAccepted
        RectangularCard(
            image: friendsItemViewModel.friendProfilePhoto,
            isHorizontal: true
        ) {
            HStack {
                Text(friendsItemViewModel.username).padding(10)
                Spacer()
                if isFriendRequest {
                        Text("Accept").padding(10)
                            .foregroundColor(.blue)
                            .onTapGesture {
                                do {
                                    try friendsItemViewModel.acceptFriend()
                                    session.levelSystemService?
                                        .generateExperienceFromAddingFriend(friend: friendsItemViewModel.friend)
                                } catch {
                                    print(error)
                                }
                            }
                }
                if isPendingRequest {
                    Text("Pending friend acceptance.")
                }
                Text("Delete").padding(10)
                        .foregroundColor(.blue)
                        .onTapGesture {
                        friendsItemViewModel.deleteFriend()
                        }
            }
        }
    }
}
