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
            ButtonWithConfirmation(buttonName: nil, warning: nil, image: "trash") {
                friendsItemViewModel.deleteFriend()
            }
        }
    }

    var innerView: some View {
        VStack(alignment: .leading) {
            friendDetail

            if friendsItemViewModel.upcomingMeetups.isEmpty {
                Text("No Upcoming Meetups").padding(.horizontal, 10)
            } else {
                Text("Upcoming Meetups:").padding(.horizontal, 10)
                ScrollView {
                    ForEach(friendsItemViewModel.upcomingMeetups) { meetup in
                        let relatedLocation =
                            friendsItemViewModel.upcomingMeetupsLocation.first(where: { $0.id == meetup.locationId })
                        HStack(alignment: .lastTextBaseline) {
                            Text(meetup.meetupDate, style: .date).frame(width: 200, alignment: .leading)
                            Text(relatedLocation?.name ?? "").frame(width: 200, alignment: .leading)
                        }
                        .padding(.horizontal, 10)
                    }
                }
            }

        }
    }

    var linkedView: some View {
        if let user = friendsItemViewModel.friendUser {
            let viewModel = AccountPageViewModel(session: session, achievementModel: friendsItemViewModel.achievementModel,
                                                 user: user, imageModel: friendsItemViewModel.imageModel)
            return AnyView(NavigationLink(destination: AccountPageView(acccountPageViewModel: viewModel)) {
                innerView
            })
        } else {
            return AnyView(innerView)
        }
    }

    var body: some View {
        RectangularCard(
            image: friendsItemViewModel.friendProfilePhoto,
            isHorizontal: true
        ) {
            linkedView
        }
    }
}
