//
//  LocationMapViewModel.swift
//  Trippy
//
//  Created by QL on 16/3/21.
//

import Combine

class LocationMapViewModel: ObservableObject {
    @Published var locationModel: LocationModel<FBStorage<FBLocation>>
    @Published var locations: [Location] = []
    let imageModel: ImageModel
    private var cancellables: Set<AnyCancellable> = []

    init(locationModel: LocationModel<FBStorage<FBLocation>>, imageModel: ImageModel) {
        self.locationModel = locationModel
        self.imageModel = imageModel
        $locationModel
          .compactMap { $0.locations }
          .assign(to: \.locations, on: self)
          .store(in: &cancellables)
    }
}
