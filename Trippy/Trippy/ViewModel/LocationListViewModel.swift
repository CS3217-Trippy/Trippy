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

    func fetchRecommendedLocations() {
        locationModel.fetchRecommendedLocations()
    }

    init(locationModel: LocationModel<FBStorage<FBLocation>>) {
        self.locationModel = locationModel
        locationModel.$locations.map { cards in
            cards.map(LocationCardViewModel.init)
        }.assign(to: \.locationCardViewModels, on: self)
        .store(in: &cancellables)

        locationModel.$recommendedLocations.map { cards in
            cards.map(LocationCardViewModel.init)
        }
        .assign(to: \.recommendedLocationViewModels, on: self)
        .store(in: &cancellables)
    }
}
