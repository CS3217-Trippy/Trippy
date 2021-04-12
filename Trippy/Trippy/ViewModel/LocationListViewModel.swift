//
//  LocationListViewModel.swift
//  Trippy
//
//  Created by QL on 13/3/21.
//

import Combine

class LocationListViewModel: ObservableObject {
    @Published var locationModel: LocationModel<FBStorage<FBLocation>>
    @Published var locationCardViewModels: [LocationCardViewModel] = []
    @Published var recommendedLocationViewModels: [LocationCardViewModel] = []
    private var cancellables: Set<AnyCancellable> = []
    let imageModel: ImageModel

    func fetchRecommendedLocations() {
        locationModel.fetchRecommendedLocations()
    }

    init(locationModel: LocationModel<FBStorage<FBLocation>>, imageModel: ImageModel) {
        self.locationModel = locationModel
        self.imageModel = imageModel
        locationModel.$locations.map { cards in
            cards.map { location in
                LocationCardViewModel(location: location, imageModel: imageModel)
            }
        }.assign(to: \.locationCardViewModels, on: self)
        .store(in: &cancellables)

        locationModel.$recommendedLocations.map { cards in
            cards.map { location in
                LocationCardViewModel(location: location, imageModel: imageModel)
            }
        }
        .assign(to: \.recommendedLocationViewModels, on: self)
        .store(in: &cancellables)
    }
}
