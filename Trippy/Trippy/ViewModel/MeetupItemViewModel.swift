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
    var imageModel: ImageModel
    private var meetupModel: MeetupModel<FBStorage<FBMeetup>>
    init(meetupItem: Meetup, meetupModel: MeetupModel<FBStorage<FBMeetup>>, imageModel: ImageModel) {
        self.meetupItem = meetupItem
        self.meetupModel = meetupModel
        self.imageModel = imageModel
        fetchImage()
    }

    private func fetchImage() {
        let id = meetupItem.locationImageId
        guard let imageId = id else {
            return
        }
        imageModel.fetch(ids: [imageId]) { images in
            if !images.isEmpty {
                self.image = images[0]
            }
        }
    }

    @Published var image: UIImage?
    private var cancellables: Set<AnyCancellable> = []
    var locationName: String {
        meetupItem.locationName
    }
    var userDescription: String {
        meetupItem.userDescription
    }
    var dateOfMeetup: String {
        meetupItem.meetupDate.dateTimeStringFromDate
    }
    var locationCategory: String {
        meetupItem.locationCategory.rawValue.capitalized
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
}
