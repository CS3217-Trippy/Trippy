//
//  LocationMapViewModel.swift
//  Trippy
//
//  Created by QL on 16/3/21.
//

import Combine

class LocationMapViewModel: ObservableObject {
    @Published var locationModel: LocationModel<FBImageSupportedStorage<FBLocation>>
    @Published var locations: [Location] = []
    private var cancellables: Set<AnyCancellable> = []

    init(locationModel: LocationModel<FBImageSupportedStorage<FBLocation>>) {
        self.locationModel = locationModel
        $locationModel
          .compactMap { $0.locations }
          .assign(to: \.locations, on: self)
          .store(in: &cancellables)
    }
}
