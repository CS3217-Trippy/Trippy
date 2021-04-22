//
//  LocationCardViewModel.swift
//  Trippy
//
//  Created by QL on 13/3/21.
//

import Foundation
import UIKit

import Combine

class LocationCardViewModel: Identifiable, ObservableObject {
    @Published var location: Location
    let ratingModel: RatingModel<FBStorage<FBRating>>
    @Published var image: UIImage?
    private var cancellables: Set<AnyCancellable> = []
    private(set) var id = ""
    let imageModel: ImageModel
    var bucketItems: [BucketItem] = []
    var meetups: [Meetup] = []
    var userId: String

    init(location: Location, imageModel: ImageModel, ratingModel: RatingModel<FBStorage<FBRating>>,
         bucketModel: BucketModel<FBStorage<FBBucketItem>>, meetupModel: MeetupModel<FBStorage<FBMeetup>>, userId: String) {
        self.location = location
        self.imageModel = imageModel
        self.ratingModel = ratingModel
        self.userId = userId
        bucketModel.$bucketItems.sink { bucketItems in
            self.bucketItems = bucketItems
        }.store(in: &cancellables)
        meetupModel.$meetupItems.sink { meetups in
            self.meetups = meetups
        }.store(in: &cancellables)
        $location
          .compactMap { $0.id }
          .assign(to: \.id, on: self)
          .store(in: &cancellables)
        fetchImage()
    }

    var isInBucketlist: Bool {
        bucketItems.contains { $0.locationId == location.id }
    }

    var meetupDate: Date? {
        meetups.first(where: { $0.locationId == location.id && $0.userIds.contains(userId) })?.meetupDate
    }

    private func fetchImage() {
        let id = location.imageId
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
        location.name
    }

    var caption: String {
        let street = location.placemark?.thoroughfare
        var formattedStreet = ""
        if let street = street {
            formattedStreet = street + ", "
        }
        let city = location.placemark?.locality ?? ""

        return formattedStreet + city
    }

    var category: String {
        location.category.rawValue.capitalized
    }

    var averageRatingDescription: String {
        guard let rating = ratingModel.getAverageRating(for: location) else {
            return "No ratings yet"
        }
        let roundedRating = String(format: "%.1f", rating)
        return "Rating: \(roundedRating)/5.0"
    }
}
