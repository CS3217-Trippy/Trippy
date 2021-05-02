//
//  MeetupItemViewModel.swift
//  Trippy
//
//  Created by Lim Chun Yong on 12/4/21.
//

import Combine
import Foundation
import UIKit

final class MeetupItemViewModel: ObservableObject, Identifiable {
    @Published var meetupItem: Meetup
    @Published var location: Location?
    @Published var locationId: String?
    @Published var image: UIImage?
    var chatModel: ChatModel<FBStorage<FBChatMessage>>
    @Published var locationDetailViewModel: LocationDetailViewModel?
    var imageModel: ImageModel
    private let locationModel: LocationModel<FBStorage<FBLocation>>
    private var meetupModel: MeetupModel<FBStorage<FBMeetup>>
    init(meetupItem: Meetup, meetupModel: MeetupModel<FBStorage<FBMeetup>>,
         imageModel: ImageModel,
         locationModel: LocationModel<FBStorage<FBLocation>>,
         locationDetailViewModel: LocationDetailViewModel?
         ) {
        self.meetupItem = meetupItem
        self.meetupModel = meetupModel
        self.imageModel = imageModel
        self.locationModel = locationModel
        self.locationDetailViewModel = locationDetailViewModel
        let chatStorage = FBStorage<FBChatMessage>()
        self.chatModel = ChatModel<FBStorage<FBChatMessage>>(storage: chatStorage, meetupId: meetupItem.id)
        locationModel.fetchLocationWithId(id: meetupItem.locationId, handler: fetchLocation)
    }

    private func fetchLocation(location: Location) {
        if let id = location.imageId {
            imageModel.fetch(ids: [id]) { images in
                if !images.isEmpty {
                    self.image = images[0]
                }
            }
        }
        self.location = location
        self.locationId = location.id
    }

    private var cancellables: Set<AnyCancellable> = []
    var locationName: String? {
        location?.name
    }
    var userDescription: String {
        meetupItem.userDescription
    }
    var dateOfMeetup: String {
        meetupItem.meetupDate.dateTimeStringFromDate
    }
    var locationCategory: String? {
        location?.category.rawValue.capitalized
    }

    func remove(userId: String?) throws {
        guard let id = userId else {
            throw MeetupError.invalidUser
        }
        let hostId = meetupItem.hostUserId
        if id == hostId {
            meetupModel.removeMeetup(meetup: meetupItem)
        } else {
            meetupItem.userIds.removeAll {
                $0 == id
            }
            try meetupModel.updateMeetup(meetup: meetupItem, handler: nil)
        }
    }

    func joinMeetup(userId: String?, levelSystemService: LevelSystemService?) throws {
        guard let id = userId else {
            throw MeetupError.invalidUser
        }
        let hostId = meetupItem.hostUserId
        let isMeetupOwner = id == hostId
        let isInMeetup = meetupItem.userIds.contains(id)
        if isMeetupOwner || isInMeetup {
            return
        }
        meetupItem.userIds.append(id)
        try meetupModel.updateMeetup(meetup: meetupItem) { meetup in
            levelSystemService?.generateExperienceFromJoiningMeetup(meetup: meetup)
        }
    }

    func userJoinedMeetup(userId: String?) -> Bool {
        guard let id = userId else {
            return false
        }
        return id == meetupItem.hostUserId || meetupItem.userIds.contains(id)
    }
}
