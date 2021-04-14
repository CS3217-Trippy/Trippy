//
//  LocationDetailViewModel.swift
//  Trippy
//
//  Created by QL on 15/3/21.
//

import Combine
import Contacts
import UIKit

class LocationDetailViewModel: ObservableObject {
    @Published var location: Location
    private let imageModel: ImageModel
    private var cancellables: Set<AnyCancellable> = []
    let ratingModel: RatingModel<FBStorage<FBRating>>
    @Published var image: UIImage?

    init(location: Location, imageModel: ImageModel, ratingModel: RatingModel<FBStorage<FBRating>>) {
        self.location = location
        self.imageModel = imageModel
        self.ratingModel = ratingModel
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

    var averageRatingDescription: String {
        guard let rating = ratingModel.getAverageRating(for: location) else {
            return "No ratings yet"
        }
        let roundedRating = String(format: "%.1f", rating)
        return "Rating: \(roundedRating)/5.0"
    }
}
