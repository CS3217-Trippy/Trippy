//
//  FriendsListViewModel.swift
//  Trippy
//
//  Created by Fidella Widjojo on 16/03/21.
//

import Foundation
import Combine

final class FriendsListViewModel: ObservableObject {
    @Published var friendsList: [FriendsItemViewModel] = []
    private var cancellables: Set<AnyCancellable> = []
    private var friendsListModel: FriendsListModel<FBUserRelatedStorage<FBFriend>>

    init(friendsListModel: FriendsListModel<FBUserRelatedStorage<FBFriend>>) {
        self.friendsListModel = friendsListModel
        friendsListModel.$friendsList.map {
            $0.map {
                FriendsItemViewModel(friend: $0, model: friendsListModel)
            }
        }.assign(to: \.friendsList, on: self).store(in: &cancellables)
    }

    func fetch() {
        friendsListModel.getFriendsList()
    }
}
