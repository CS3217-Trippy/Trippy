//
//  LocationCardViewModel.swift
//  Trippy
//
//  Created by QL on 13/3/21.
//

import Foundation

import Combine

class LocationCardViewModel: Identifiable, ObservableObject {
    @Published var location: Location
    @Published var ratings: [Rating] = []
    private let ratingModel: RatingModel<FBUserRelatedStorage<FBRating>>
    private var cancellables: Set<AnyCancellable> = []
    private(set) var id = ""

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

    init(location: Location, ratingModel: RatingModel<FBUserRelatedStorage<FBRating>>) {
        self.location = location
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
    }
}
