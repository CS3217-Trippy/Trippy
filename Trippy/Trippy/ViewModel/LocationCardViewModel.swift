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
    @Published var ratings: [Rating] = []
    private let ratingModel: RatingModel<FBStorage<FBRating>>
    @Published var image: UIImage?
    private var cancellables: Set<AnyCancellable> = []
    private(set) var id = ""
    let imageModel: ImageModel

    init(location: Location, imageModel: ImageModel, ratingModel: RatingModel<FBStorage<FBRating>>) {
        self.location = location
        self.imageModel = imageModel
        self.ratingModel = ratingModel
        $location
          .compactMap { $0.id }
          .assign(to: \.id, on: self)
          .store(in: &cancellables)
        ratingModel.$ratings
            .sink { publishedRatings in
                self.ratings = publishedRatings.filter {$0.locationId == location.id}
            }
            .store(in: &cancellables)
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
    
    var rating: Float {
        if ratings.isEmpty {
            return 0.0
        }
        return Float(ratings.reduce(0, {$0 + $1.score})) / Float(ratings.count)
    }
}
