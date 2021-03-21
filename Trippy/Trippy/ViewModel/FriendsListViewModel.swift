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
    var friendsListModel: FriendsListModel

    init(session: SessionStore) {
        friendsListModel = FriendsListModel(session: session)
        friendsListModel.$friendsList.map {
            $0.map {
                FriendsItemViewModel(user: $0)
            }
        }.assign(to: \.friendsList, on: self).store(in: &cancellables)
        friendsListModel.getFriendsList()
    }
}
