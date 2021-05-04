//
//  AddMeetupViewModel.swift
//  Trippy
//
//  Created by Lim Chun Yong on 13/4/21.
//

import Foundation
import Combine
import UIKit

class CreateMeetupViewModel: ObservableObject, Identifiable {
    private var meetupModel: MeetupModel<FBStorage<FBMeetup>>
    private var cancellables: Set<AnyCancellable> = []
    private var location: Location
    private var user: User?
    private var friendsListModel: FriendsListModel<FBStorage<FBFriend>>
    private var imageModel = ImageModel(storage: FBImageStorage())
    private var userModel = UserModel(storage: FBStorage<FBUser>())
    private var meetupNotificationModel: MeetupNotificationModel<FBStorage<FBMeetupNotification>>
    @Published var images: [String?: UIImage?] = [:]
    @Published var friendsList: [User] = []
    @Published var usernames: [String?: String] = [:]

    init(location: Location, session: SessionStore) {
        self.location = location
        self.user = session.currentLoggedInUser
        self.meetupModel = MeetupModel<FBStorage<FBMeetup>>(storage: FBStorage<FBMeetup>(), userId: user?.id)
        self.friendsListModel = FriendsListModel<FBStorage<FBFriend>>(storage: FBStorage<FBFriend>(), userId: user?.id)
        self.meetupNotificationModel = MeetupNotificationModel
        <FBStorage<FBMeetupNotification>>(storage: FBStorage<FBMeetupNotification>(),
                                          userId: user?.id)
        friendsListModel.getFriendsList { friends in
            self.userModel.fetchUsers {users in
                self.getUsers(users: users, friends: friends)
            }
        }
    }

    var privacyOptions: [String] {
        MeetupPrivacy.allCases.map { $0.rawValue }
    }

    private func getUsers(users: [User], friends: [Friend]) {
        self.friendsList = users.filter { user in
            friends.contains {
                $0.friendId == user.id && $0.userId == self.user?.id
            }
        }
    }

    private func getImage(friend: User) {
        if let id = friend.imageId {
            imageModel.fetch(ids: [id]) { images in
                if !images.isEmpty {
                    self.images[id] = images[0]
                }
            }
        }
    }

    /// Saves the form and adds meetup to model
    func saveForm(meetupDate: Date, userDescription: String, meetupPrivacy: String, friends: [User]) throws {
        let meetup = try buildMeetup(friends: friends,
                                     meetupPrivacy: meetupPrivacy,
                                     meetupDate: meetupDate,
                                     userDescription: userDescription)
        try meetupModel.addMeetup(meetup: meetup)
        try sendNotifications(meetup: meetup)
    }

    private func sendNotifications(meetup: Meetup) throws {
        guard let meetupId = meetup.id else {
            return
        }
        let users = meetup.userIds
        for user in users {
            let meetupNotification = MeetupNotification(meetupId: meetupId, userId: user, isNotified: false)
            try meetupNotificationModel.addNotification(item: meetupNotification)
        }
    }

    private func buildMeetup(friends: [User],
                             meetupPrivacy: String,
                             meetupDate: Date,
                             userDescription: String) throws -> Meetup {
        guard let locationId = location.id else {
            throw MeetupError.invalidLocation
        }
        guard let userId = user?.id else {
            throw MeetupError.invalidUser
        }

        guard let privacy = MeetupPrivacy(rawValue: meetupPrivacy) else {
            throw MeetupError.invalidPrivacy
        }

        guard meetupDate > Date() else {
            throw MeetupError.invalidDate
        }

        let userIds = getUserIdsFromUsers(friends: friends)
        let meetup = Meetup(id: nil, meetupPrivacy: privacy, userIds: userIds, hostUserId: userId,
                            locationId: locationId, meetupDate: meetupDate, dateAdded: Date(),
                            userDescription: userDescription)
        return meetup
    }

    private func getUserPhotosFromUsers(friends: [User]) -> [String] {
        var userPhotos: [String] = []
        for friend in friends {
            guard let friendData = userModel.users.first(where: { $0.id == friend.id }) else {
                continue
            }
            if let userPhoto = friendData.imageId {
                userPhotos.append(userPhoto)
            }
        }
        return userPhotos
    }

    private func getUserIdsFromUsers(friends: [User]) -> [String] {
        var userIds: [String] = []
        for friend in friends {
            guard let userId = friend.id else {
                continue
            }
            userIds.append(userId)
        }
        return userIds
    }
}
