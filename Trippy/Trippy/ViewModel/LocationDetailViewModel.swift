//
//  LocationDetailViewModel.swift
//  Trippy
//
//  Created by QL on 15/3/21.
//

import Combine
import Contacts
import UIKit
import CoreLocation

class LocationDetailViewModel: ObservableObject {
    @Published var location: Location
    let imageModel: ImageModel
    private var cancellables: Set<AnyCancellable> = []
    var bucketModel: BucketModel<FBStorage<FBBucketItem>>
    var meetupModel: MeetupModel<FBStorage<FBMeetup>>
    private var userId: String?
    let ratingModel: RatingModel<FBStorage<FBRating>>
    var locationModel: LocationModel<FBStorage<FBLocation>>
    var itineraryModel: ItineraryModel<FBStorage<FBItineraryItem>>

    @Published var image: UIImage?

    init(location: Location, imageModel: ImageModel, ratingModel: RatingModel<FBStorage<FBRating>>,
         bucketModel: BucketModel<FBStorage<FBBucketItem>>, meetupModel: MeetupModel<FBStorage<FBMeetup>>,
         locationModel: LocationModel<FBStorage<FBLocation>>,
         itineraryModel: ItineraryModel<FBStorage<FBItineraryItem>>, userId: String?) {
        self.location = location
        self.imageModel = imageModel
        self.ratingModel = ratingModel
        self.bucketModel = bucketModel
        self.meetupModel = meetupModel
        self.locationModel = locationModel
        self.itineraryModel = itineraryModel
        self.userId = userId
        fetchImage()
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

    var address: String {
        let postalAddressFormatter = CNPostalAddressFormatter()
        postalAddressFormatter.style = .mailingAddress
        var addressString: String?
        if let postalAddress = location.placemark?.postalAddress {
            addressString = postalAddressFormatter.string(from: postalAddress)
        }
        return addressString ?? ""
    }

    var description: String {
        location.description
    }

    var category: String {
        location.category.rawValue.capitalized
    }

    var locationCoordinates: CLLocationCoordinate2D {
        location.coordinates
    }

    var averageRatingDescription: String {
        guard let rating = ratingModel.getAverageRating(for: location) else {
            return "No ratings yet"
        }
        let roundedRating = String(format: "%.1f", rating)
        return "Rating: \(roundedRating)/5.0"
    }

    var isInBucketlist: Bool {
        bucketModel.bucketItems.contains { $0.locationId == location.id }
    }

    var upcomingMeetups: [Meetup] {
        meetupModel.meetupItems.sorted(by: { $0.meetupDate < $1.meetupDate })
            .filter {
                $0.locationId == location.id && $0.meetupDate > Date()
                    && ($0.hostUserId == userId || $0.userIds.contains(userId ?? ""))
            }
    }

    var meetupDate: String? {
        upcomingMeetups.first?.meetupDate.dateTimeStringFromDate
    }

    var numItinerary: Int {
        itineraryModel.itineraryItems.filter { $0.userId == userId && $0.locationId == location.id }
            .count
    }
}
