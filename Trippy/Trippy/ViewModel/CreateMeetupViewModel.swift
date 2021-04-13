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
    private var bucketItem: BucketItem
    private var user: User?
    private var friendsListModel: FriendsListModel<FBStorage<FBFriend>>
    private var imageModel = ImageModel(storage: FBImageStorage())
    @Published var images: [String?: UIImage?] = [:]
    @Published var friendsList: [Friend] = []

    init(bucketItem: BucketItem, session: SessionStore) {
        self.bucketItem = bucketItem
        self.user = session.currentLoggedInUser
        self.meetupModel = MeetupModel<FBStorage<FBMeetup>>(storage: FBStorage<FBMeetup>(), userId: user?.id)
        self.friendsListModel = FriendsListModel<FBStorage<FBFriend>>(storage: FBStorage<FBFriend>(), userId: user?.id)
        friendsListModel.$friendsList.map {
            $0.map {
                self.getImage(friend: $0)
                return $0
            }
        }.assign(to: \.friendsList, on: self).store(in: &cancellables)
        friendsListModel.getFriendsList()
    }

    private func getImage(friend: Friend) {
        if let id = friend.friendProfilePhoto {
            imageModel.fetch(ids: [id]) { images in
                if !images.isEmpty {
                    self.images[id] = images[0]
                }
            }
        }
    }

    func saveForm(meetupDate: Date, userDescription: String, friends: [Friend]) throws {
        let meetup = try buildMeetup(friends: friends, meetupDate: meetupDate, userDescription: userDescription)
        try meetupModel.addMeetup(meetup: meetup)
    }

    private func buildMeetup(friends: [Friend], meetupDate: Date, userDescription: String) throws -> Meetup {
        guard let locationId = bucketItem.id else {
            fatalError("Location should have id")
        }
        guard let userId = user?.id else {
            fatalError("User should be logged in")
        }
        guard let username = user?.username else {
            fatalError("User should have username")
        }
        let imageId = bucketItem.locationImageId
        let userIds = getUserIdsFromUsers(friends: friends)
        let userPhotos = getUserPhotosFromUsers(friends: friends)
        let meetup = Meetup(id: nil,
                            userIds: userIds,
                            userProfilePhotoIds: userPhotos,
                            hostUsername: username,
                            hostUserId: userId,
                            locationImageId: imageId,
                            locationName: bucketItem.locationName,
                            locationCategory: bucketItem.locationCategory,
                            locationId: locationId,
                            meetupDate: meetupDate,
                            dateAdded: Date(),
                            userDescription: userDescription)
        return meetup
    }

    private func getUserPhotosFromUsers(friends: [Friend]) -> [String] {
        var userPhotos: [String] = []
        for friend in friends {
            if let userPhoto = friend.friendProfilePhoto {
                userPhotos.append(userPhoto)
            }
        }
        return userPhotos
    }

    private func getUserIdsFromUsers(friends: [Friend]) -> [String] {
        var userIds: [String] = []
        for friend in friends {
            userIds.append(friend.friendId)
        }
        return userIds
    }
}
