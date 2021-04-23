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
    private let meetupModel: MeetupModel<FBStorage<FBMeetup>>
    private var user: User
    let imageModel: ImageModel

    init(
        friendsListModel: FriendsListModel<FBStorage<FBFriend>>,
        imageModel: ImageModel,
        meetupModel: MeetupModel<FBStorage<FBMeetup>>,
        user: User
    ) {
        self.friendsListModel = friendsListModel
        self.imageModel = imageModel
        self.meetupModel = meetupModel
        self.user = user
        friendsListModel.$friendsList.map {
            $0.filter {
                $0.userId == self.user.id
            }.map {
                FriendsItemViewModel(
                    friend: $0, model: friendsListModel, imageModel: imageModel, meetupModel: meetupModel, user: user)
            }
        }.assign(to: \.friendsList, on: self).store(in: &cancellables)
    }

    func fetch() {
        friendsListModel.getFriendsList(handler: nil)
    }
}
