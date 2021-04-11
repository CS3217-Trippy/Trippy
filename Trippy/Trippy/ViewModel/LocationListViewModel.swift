//
//  LocationListViewModel.swift
//  Trippy
//
//  Created by QL on 13/3/21.
//

import Combine

class LocationListViewModel: ObservableObject {
    @Published var locationModel: LocationModel<FBImageSupportedStorage<FBLocation>>
    @Published var ratingModel: RatingModel<FBUserRelatedStorage<FBRating>>
    @Published var locationCardViewModels: [LocationCardViewModel] = []
    @Published var recommendedLocationViewModels: [LocationCardViewModel] = []
    private var cancellables: Set<AnyCancellable> = []

    func fetchRecommendedLocations() {
        locationModel.fetchRecommendedLocations()
    }

    init(locationModel: LocationModel<FBImageSupportedStorage<FBLocation>>, ratingModel: RatingModel<FBUserRelatedStorage<FBRating>>) {
        self.locationModel = locationModel
        self.ratingModel = ratingModel
//        locationModel.$locations.combineLatest(ratingModel.$ratings)
//        .sink { locations, ratings in
//            locations.forEach { location in
//                let filteredRatings = ratings.filter {$0.locationId == location.id}
//                self.locationCardViewModels.append(.init(location: location))
//            }
//        }
//        .store(in: &cancellables)
        locationModel.$locations.map { cards in
            cards.map { location in
                LocationCardViewModel.init(location: location,ratingModel: ratingModel)
            }
        }.assign(to: \.locationCardViewModels, on: self)
        .store(in: &cancellables)
        
        

        locationModel.$recommendedLocations.map { cards in
            cards.map { location in
                LocationCardViewModel.init(location: location,ratingModel: ratingModel)
            }
        }
        .assign(to: \.recommendedLocationViewModels, on: self)
        .store(in: &cancellables)
    }
}
