//
//  FollowersListModel.swift
//  Trippy
//
//  Created by Fidella Widjojo on 16/03/21.
//

import Foundation

final class FollowersListModel {
    var followersList: [User] = []
    var storage: UserStorage = UserStorage()
    var updateViewModel: () -> () = {}

    func setUpdate(updateViewModel: @escaping () -> ()) {
        self.updateViewModel = updateViewModel
    }

    func setFollowersList(user: User) {
        print("getList")
        followersList = []
        self.storage.getFollowersList(user: user, handler: addFollowerFromStorage)
    }

    func addFollowerFromStorage(user: User) {
        followersList.append(user)
        updateViewModel()
    }
}
