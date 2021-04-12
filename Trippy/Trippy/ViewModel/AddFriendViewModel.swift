//
//  AddFriendViewModel.swift
//  Trippy
//
//  Created by Fidella Widjojo on 19/03/21.
//

import Foundation
import Combine
import UIKit

final class AddFriendViewModel: ObservableObject {
    @Published var usersList: [User] = []
    @Published var images: [String?: UIImage?] = [:]
    private var cancellables: Set<AnyCancellable> = []
    private var friendsListModel: FriendsListModel<FBStorage<FBFriend>>
    private var userStorage: FBStorage<FBUser>
    private var imageModel = ImageModel(storage: FBImageStorage())
    private var user: User?

    init(session: SessionStore) {
        userStorage = session.userStorage
        self.user = session.currentLoggedInUser
        let storage = FBStorage<FBFriend>()
        self.friendsListModel = FriendsListModel<FBStorage<FBFriend>>(storage: storage, userId: user?.id)
        userStorage.storedItems.assign(to: \.usersList, on: self).store(in: &cancellables)
    }

    func getImage(user: User?) {
        guard let user = user, let id = user.imageId else {
            return
        }
        imageModel.fetch(ids: [id]) { images in
            if !images.isEmpty {
                self.images[id] = images[0]
            }
        }
    }

    func getUsers() {
        userStorage.fetch { users in
            self.usersList = users
            for user in users {
                self.getImage(user: user)
            }
        }
    }

    func addFriend(currentUser: User, user: User) throws {
        let friend = createFriendRequest(from: currentUser, to: user)
        try friendsListModel.addFriend(friend: friend)
    }

    private func createFriendRequest(from: User, to: User) -> Friend {
        guard
            let userId = to.id,
            let friendId = from.id
        else {
            fatalError("Users should have id")
        }
        return Friend(
            userId: userId,
            username: to.username,
            userProfilePhoto: to.imageId,
            friendId: friendId,
            friendUsername: from.username,
            friendProfilePhoto: from.imageId,
            hasAccepted: false
        )
    }
}
