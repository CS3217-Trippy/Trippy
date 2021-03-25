//
//  LocationListViewModel.swift
//  Trippy
//
//  Created by QL on 13/3/21.
//

import Combine

class LocationListViewModel: ObservableObject {
    @Published var locationModel: LocationModel<FBImageSupportedStorage<FBLocation>>
    @Published var locationCardViewModels: [LocationCardViewModel] = []
    private var cancellables: Set<AnyCancellable> = []

    init(locationModel: LocationModel<FBImageSupportedStorage<FBLocation>>) {
        self.locationModel = locationModel
        locationModel.$locations.map { cards in
            cards.map(LocationCardViewModel.init)
        }
        .assign(to: \.locationCardViewModels, on: self)
        .store(in: &cancellables)
    }
}
