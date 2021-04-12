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
    private var friendsListModel: FriendsListModel<FBStorage<FBFriend>>
    let imageModel: ImageModel

    init(friendsListModel: FriendsListModel<FBStorage<FBFriend>>, imageModel: ImageModel) {
        self.friendsListModel = friendsListModel
        self.imageModel = imageModel
        friendsListModel.$friendsList.map {
            $0.map {
                FriendsItemViewModel(friend: $0, model: friendsListModel, imageModel: imageModel)
            }
        }.assign(to: \.friendsList, on: self).store(in: &cancellables)
    }

    func fetch() {
        friendsListModel.getFriendsList()
    }
}
