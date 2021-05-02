//
//  FriendsItemViewModel.swift
//  Trippy
//
//  Created by Fidella Widjojo on 16/03/21.
//

import Foundation
import UIKit

final class FriendsItemViewModel: ObservableObject, Identifiable {
    @Published var friend: Friend
    @Published var friendProfilePhoto: UIImage?
    private var friendsModel: FriendsListModel<FBStorage<FBFriend>>
    private var userModel = UserModel(storage: FBStorage<FBUser>())
    private var meetupModel: MeetupModel<FBStorage<FBMeetup>>
    var imageModel: ImageModel
    var achievementModel: AchievementModel<FBStorage<FBAchievement>>
    private var locationModel: LocationModel<FBStorage<FBLocation>>
    private var user: User
    @Published var username: String = ""
    @Published var hasAccepted: Bool
    @Published var hasFriendAccepted: Bool = false
    @Published var upcomingMeetups = [Meetup]()
    @Published var upcomingMeetupsLocation = [Location]()
    @Published var friendUser: User?

    init(
        friend: Friend,
        model: FriendsListModel<FBStorage<FBFriend>>,
        imageModel: ImageModel,
        meetupModel: MeetupModel<FBStorage<FBMeetup>>,
        locationModel: LocationModel<FBStorage<FBLocation>>,
        user: User
    ) {
        self.meetupModel = meetupModel
        self.friendsModel = model
        self.imageModel = imageModel
        self.locationModel = locationModel
        self.friend = friend
        self.user = user
        self.hasAccepted = friend.hasAccepted
        self.achievementModel = AchievementModel(storage: FBStorage<FBAchievement>())
        userModel.fetchUsers(handler: fetchFriend)
    }

    private func fetchFriend(users: [User]) {
        guard let friendData = users.first(where: { $0.id == friend.friendId }) else {
            return
        }
        if let id = friendData.imageId {
            imageModel.fetch(ids: [id]) { images in
                if !images.isEmpty {
                    self.friendProfilePhoto = images[0]
                }
            }
        }
        friendUser = friendData
        username = friendData.username
        self.hasFriendAccepted = friendsModel.friendsList.first(
            where: { $0.userId == friend.friendId && $0.friendId == friend.userId })?.hasAccepted ?? false
        fetchUpcomingMeetups()
    }

    private func fetchUpcomingMeetups() {
        meetupModel.fetchAllMeetupsWithHandler { [self] meetups in
            upcomingMeetups = meetups.filter({
                let hostedByUserAndFriendJoined = $0.hostUserId == user.id && $0.userIds.contains(friend.friendId)
                let hostedByFriendAndUserJoined = $0.hostUserId == friend.friendId && $0.userIds.contains(user.id ?? "")
                let joinedByFriendAndUser = $0.userIds.contains(friend.friendId) && $0.userIds.contains(user.id ?? "")
                let isNotExpired = $0.meetupDate >= Date()
                return (hostedByUserAndFriendJoined || hostedByFriendAndUserJoined || joinedByFriendAndUser) && isNotExpired
            }).sorted(by: { $0.meetupDate < $1.meetupDate })
            fetchLocationRelatedToMeetup()
        }
    }

    private func fetchLocationRelatedToMeetup() {
        _ = upcomingMeetups.map({
            locationModel.fetchLocationWithId(id: $0.locationId) { [self] location in
                upcomingMeetupsLocation.append(location)
            }
        })
    }

    func acceptFriend() throws {
        if friend.hasAccepted {
            return
        }
        try friendsModel.acceptFriendRequest(friendId: friend.friendId)
    }

    func deleteFriend() {
        friendsModel.deleteFriends(friendId: friend.friendId)
    }
}
