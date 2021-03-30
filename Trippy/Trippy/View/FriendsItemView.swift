//
//  FriendsItemView.swift
//  Trippy
//
//  Created by Fidella Widjojo on 16/03/21.
//

import SwiftUI
import URLImage

struct FriendsItemView: View {
    @EnvironmentObject var session: FBSessionStore
    @ObservedObject var friendsItemViewModel: FriendsItemViewModel

    var profilePhoto: some View {
        if let url = friendsItemViewModel.friendProfilePhoto {
            return AnyView(URLImage(url: url) {image in
                image.cardImageModifier()
            })
        } else {
            return AnyView(Image("Placeholder").cardImageModifier())
        }
    }

    var body: some View {
        let isFriendRequest = !friendsItemViewModel.hasAccepted
        RectangularCard(
            width: UIScreen.main.bounds.width - 10,
            height: 210,
            viewBuilder: { HStack {
                profilePhoto
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
        )
    }
}
