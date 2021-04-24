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

    var friendDetail: some View {
        let isFriendRequest = !friendsItemViewModel.hasAccepted
        let isPendingRequest = friendsItemViewModel.hasAccepted && !friendsItemViewModel.hasFriendAccepted
        return HStack {
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

    var innerView: some View {
        VStack(alignment: .leading) {
            friendDetail
            Text("Upcoming Meetups:").padding(.horizontal, 10)
            ScrollView {
                ForEach(friendsItemViewModel.upcomingMeetups) { meetup in
                    HStack {
                        Text(meetup.meetupDate, style: .date).padding(.horizontal, 10)
                    }
                }
            }
        }
    }

    var body: some View {
        RectangularCard(
            image: friendsItemViewModel.friendProfilePhoto,
            isHorizontal: true
        ) {
            innerView
        }
    }
}
