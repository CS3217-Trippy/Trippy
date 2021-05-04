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
    private var userModel = UserModel(storage: FBStorage<FBUser>())
    private var imageModel = ImageModel(storage: FBImageStorage())
    private var user: User?

    init(session: SessionStore) {
        self.user = session.currentLoggedInUser
        let storage = FBStorage<FBFriend>()
        self.friendsListModel = FriendsListModel<FBStorage<FBFriend>>(storage: storage, userId: user?.id)
        self.friendsListModel.getFriendsList(handler: getUsers)

    }

    func getUsers(friendsList: [Friend]) {
        userModel.$users.map {
            let filteredUsers = $0.filter { user in
                user.id != self.user?.id
                    && !friendsList.contains(where: { friend in
                        friend.userId == self.user?.id && friend.friendId == user.id
                    })
            }
            for user in filteredUsers {
                self.getImage(user: user)
            }
            return filteredUsers
        }.assign(to: \.usersList, on: self).store(in: &cancellables)
    }

    private func getImage(user: User?) {
        guard let user = user, let id = user.imageId else {
            return
        }
        imageModel.fetch(ids: [id]) { images in
            if !images.isEmpty {
                self.images[id] = images[0]
            }
        }
    }

    func fetchUsers() {
        userModel.fetchUsers(handler: {$0.forEach {
            self.getImage(user: $0)
        }})
    }

    func addFriend(currentUser: User, user: User) throws {
        var friend = createFriendRequest(from: currentUser, to: user, acc: false)
        try friendsListModel.addFriend(friend: friend)
        friend = createFriendRequest(from: user, to: currentUser, acc: true)
        try friendsListModel.addFriend(friend: friend)
    }

    private func createFriendRequest(from: User, to: User, acc: Bool) -> Friend {
        guard
            let userId = to.id,
            let friendId = from.id
        else {
            fatalError("Users should have id")
        }
        return Friend(
            userId: userId,
            friendId: friendId,
            hasAccepted: acc
        )
    }
}
