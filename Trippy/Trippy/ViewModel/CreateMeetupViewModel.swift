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
    @Published var images: [String?: UIImage?] = [:]
    @Published var friendsList: [User] = []
    @Published var usernames: [String?: String] = [:]
    

    init(location: Location, session: SessionStore) {
        self.location = location
        self.user = session.currentLoggedInUser
        self.meetupModel = MeetupModel<FBStorage<FBMeetup>>(storage: FBStorage<FBMeetup>(), userId: user?.id)
        self.friendsListModel = FriendsListModel<FBStorage<FBFriend>>(storage: FBStorage<FBFriend>(), userId: user?.id)
        
        friendsListModel.getFriendsList(handler: nil)
        userModel.fetchUsers(handler: getUsers)
    }

    var privacyOptions: [String] {
        MeetupPrivacy.allCases.map { $0.rawValue }
    }
    
    private func getUsers(users: [User]) {
        friendsListModel.$friendsList.map {
            $0.compactMap { friend in users.first(where: { $0.id == friend.friendId }) }
                .map {
                self.getImage(friend: $0)
                return $0
                }
        }.assign(to: \.friendsList, on: self).store(in: &cancellables)
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

        let imageId = location.imageId
        let userIds = getUserIdsFromUsers(friends: friends)
        let userPhotos = getUserPhotosFromUsers(friends: friends)
        let coordinates = location.coordinates
        let meetup = Meetup(id: nil, meetupPrivacy: privacy, userIds: userIds,
                            userProfilePhotoIds: userPhotos, hostUserId: userId,
                            locationImageId: imageId, locationName: location.name,
                            locationCategory: location.category, locationId: locationId,
                            meetupDate: meetupDate, dateAdded: Date(),
                            userDescription: userDescription, coordinates: coordinates)
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
