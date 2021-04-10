//
//  AddFriendViewModel.swift
//  Trippy
//
//  Created by Fidella Widjojo on 19/03/21.
//

import Foundation
import Combine

final class AddFriendViewModel: ObservableObject {
    @Published var usersList: [User] = []
    private var cancellables: Set<AnyCancellable> = []
    private var friendsListModel: FriendsListModel<FBUserRelatedStorage<FBFriend>>
    private var userStorage: FBImageSupportedStorage<FBUser>

    init(session: SessionStore) {
        userStorage = session.userStorage
        let user = session.currentLoggedInUser
        let storage = FBUserRelatedStorage<FBFriend>(userId: user?.id)
        self.friendsListModel = FriendsListModel<FBUserRelatedStorage<FBFriend>>(storage: storage, userId: user?.id)
        userStorage.storedItems.assign(to: \.usersList, on: self).store(in: &cancellables)
    }

    func getUsers() {
        userStorage.fetch()
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
            userProfilePhoto: to.imageURL,
            friendId: friendId,
            friendUsername: from.username,
            friendProfilePhoto: from.imageURL,
            hasAccepted: false
        )
    }
}
