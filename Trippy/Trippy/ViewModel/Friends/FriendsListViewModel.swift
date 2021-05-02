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
    @Published var friendRequests: [FriendsItemViewModel] = []
    private var cancellables: Set<AnyCancellable> = []
    private var friendsListModel: FriendsListModel<FBStorage<FBFriend>>
    private let meetupModel: MeetupModel<FBStorage<FBMeetup>>
    private var user: User
    private var locationModel: LocationModel<FBStorage<FBLocation>>
    let imageModel: ImageModel

    init(
        friendsListModel: FriendsListModel<FBStorage<FBFriend>>,
        imageModel: ImageModel,
        meetupModel: MeetupModel<FBStorage<FBMeetup>>,
        locationModel: LocationModel<FBStorage<FBLocation>>,
        user: User
    ) {
        self.friendsListModel = friendsListModel
        self.imageModel = imageModel
        self.meetupModel = meetupModel
        self.locationModel = locationModel
        self.user = user
        friendsListModel.$friendsList.map {
            $0.filter {
                $0.userId == self.user.id && $0.hasAccepted
            }.map {
                FriendsItemViewModel(
                    friend: $0, model: friendsListModel,
                    imageModel: imageModel, meetupModel: meetupModel,
                    locationModel: locationModel, user: user)
            }
        }.assign(to: \.friendsList, on: self).store(in: &cancellables)

        friendsListModel.$friendsList.map {
            $0.filter {
                $0.userId == self.user.id && !$0.hasAccepted
            }.map {
                FriendsItemViewModel(
                    friend: $0, model: friendsListModel,
                    imageModel: imageModel, meetupModel: meetupModel,
                    locationModel: locationModel, user: user)
            }
        }.assign(to: \.friendRequests, on: self).store(in: &cancellables)
    }

    func fetch() {
        friendsListModel.getFriendsList(handler: nil)
    }
}
