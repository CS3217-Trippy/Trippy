//
//  FollowersListViewModel.swift
//  Trippy
//
//  Created by Fidella Widjojo on 16/03/21.
//

import Foundation

final class FollowersListViewModel: ObservableObject {
    @Published var followersList: [FollowersItemViewModel] = []
    var followersListModel: FollowersListModel

    init(user: User) {
        followersListModel = FollowersListModel()
        followersListModel.setFollowersList(user: user)
        followersListModel.setUpdate(updateViewModel: updateFollowersList)
    }

    func updateFollowersList() {
        self.followersList = followersListModel.followersList.map {
            FollowersItemViewModel(username: $0.username)
        }
    }
}
