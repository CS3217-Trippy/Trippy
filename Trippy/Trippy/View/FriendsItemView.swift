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
        if let image = friendsItemViewModel.friendProfilePhoto {
            return AnyView(Image(uiImage: image).cardImageModifier()
            )
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
//                            completeFriendCountAchievement(friend: friendsItemViewModel.friend)
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

    private func completeFriendCountAchievement(friend: Friend) {
        guard let user = session.currentLoggedInUser else {
            return
        }
        guard let userLevelSystem = session.levelSystemService?.getUserLevelSystem() else {
            fatalError("User should have level system")
        }
        var completion = userLevelSystem.friendsIdAddedBefore.count
        if !userLevelSystem.friendsIdAddedBefore.contains(friend.friendId) {
            completion += 1
        }
        let achievementsCompleted =
            session.achievementService?.checkForCompletions(
                type: .FriendCount(completion: 0),
                completion: completion
            ) ?? []
        session.achievementService?.completeAchievements(for: user, achievement: achievementsCompleted)
    }
}
