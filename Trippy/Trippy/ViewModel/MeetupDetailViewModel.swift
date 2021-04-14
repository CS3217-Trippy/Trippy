//
//  MeetupDetailViewModel.swift
//  Trippy
//
//  Created by Lim Chun Yong on 13/4/21.
//

import Combine
import Contacts
import UIKit

class MeetupDetailViewModel: ObservableObject {
    @Published var meetup: Meetup
    private let imageModel: ImageModel
    private var meetupModel: MeetupModel<FBStorage<FBMeetup>>
    private var cancellables: Set<AnyCancellable> = []
    @Published var image: UIImage?

    init(meetup: Meetup, meetupModel: MeetupModel<FBStorage<FBMeetup>>, imageModel: ImageModel) {
        self.meetup = meetup
        self.imageModel = imageModel
        self.meetupModel = meetupModel
        fetchImage()
    }

    private func fetchImage() {
        let id = meetup.locationImageId
        guard let imageId = id else {
            return
        }
        imageModel.fetch(ids: [imageId]) { images in
            if !images.isEmpty {
                self.image = images[0]
            }
        }
    }

    var title: String {
        meetup.locationName
    }

    var description: String {
        meetup.userDescription
    }

    var count: Int {
        meetup.userIds.count + 1
    }

    var host: String {
        meetup.hostUsername
    }

    var category: String {
        meetup.locationCategory.rawValue
    }

    var meetupDate: String {
        meetup.meetupDate.dateTimeStringFromDate
    }

    var dateAdded: String {
        meetup.dateAdded.dateStringFromDate
    }

    func userInMeetup(user: User?) -> Bool {
        guard let id = user?.id else {
            return false
        }
        return meetup.userIds.contains { $0 == id } || meetup.hostUserId == id
    }

    func remove(userId: String?) throws {
        guard let id = userId else {
            return
        }
        let hostId = meetup.hostUserId
        if id == hostId {
            meetupModel.removeMeetup(meetup: meetup)
        } else {
            meetup.userIds.removeAll {
                $0 == id
            }
            try meetupModel.updateMeetup(meetup: meetup)
        }
    }

}
