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
    let bucketModel: BucketModel<FBStorage<FBBucketItem>>
    let meetupModel: MeetupModel<FBStorage<FBMeetup>>
    let locationModel: LocationModel<FBStorage<FBLocation>>
    let itineraryModel: ItineraryModel<FBStorage<FBItineraryItem>>
    var userId: String

    init(location: Location, imageModel: ImageModel, ratingModel: RatingModel<FBStorage<FBRating>>,
         bucketModel: BucketModel<FBStorage<FBBucketItem>>, meetupModel: MeetupModel<FBStorage<FBMeetup>>,
         userId: String, locationModel: LocationModel<FBStorage<FBLocation>>,
         itineraryModel: ItineraryModel<FBStorage<FBItineraryItem>>) {
        self.location = location
        self.imageModel = imageModel
        self.ratingModel = ratingModel
        self.userId = userId
        self.bucketModel = bucketModel
        self.meetupModel = meetupModel
        self.locationModel = locationModel
        self.itineraryModel = itineraryModel
        $location
          .compactMap { $0.id }
          .assign(to: \.id, on: self)
          .store(in: &cancellables)
        fetchImage()
    }

    var isInBucketlist: Bool {
        bucketModel.bucketItems.contains { $0.locationId == location.id }
    }

    var meetupDate: String? {
        meetupModel.meetupItems.sorted(by: { $0.meetupDate < $1.meetupDate })
            .first(where: {
                    $0.locationId == location.id && $0.meetupDate > Date()
                        && ($0.hostUserId == userId || $0.userIds.contains(userId))
            })?.meetupDate.dateTimeStringFromDate
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
