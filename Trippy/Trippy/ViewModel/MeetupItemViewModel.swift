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
    @Published private var meetupItem: Meetup
    private var meetupModel: MeetupModel<FBStorage<FBMeetup>>
    private let imageModel: ImageModel
    private(set) var id = ""
    init(meetupItem: Meetup, meetupModel: MeetupModel<FBStorage<FBMeetup>>, imageModel: ImageModel) {
        self.meetupItem = meetupItem
        self.meetupModel = meetupModel
        self.imageModel = imageModel
        $meetupItem.compactMap { $0.id }.assign(to: \.id, on: self)
            .store(in: &cancellables)
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
    var dateAdded: Date {
        meetupItem.dateAdded
    }

    func remove(userId: String?) throws {
        guard let id = userId else {
            return
        }
        let hostId = meetupItem.hostUserId
        if id == hostId {
            meetupModel.removeMeetup(meetup: meetupItem)
        } else {
            meetupItem.userIds.removeAll {
                $0 == id
            }
            try meetupModel.updateMeetup(meetup: meetupItem)
        }
    }

}
