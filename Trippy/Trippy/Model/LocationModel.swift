//
//  LocationModel.swift
//  Trippy
//
//  Created by QL on 13/3/21.
//

import Combine
import UIKit

class LocationModel: ObservableObject {
    @Published private(set) var locations: [Location] = []
    private let storage: LocationStorage
    private var cancellables: Set<AnyCancellable> = []

    init(storage: LocationStorage) {
        self.storage = storage
        storage.locations.assign(to: \.locations, on: self)
            .store(in: &cancellables)
        fetchLocations()
    }

    func fetchLocations() {
        storage.fetchLocations()
    }

    func addLocation(location: Location, image: UIImage? = nil) throws {
        guard !locations.contains(where: { $0.id == location.id }) else {
            return
        }

        try storage.addLocation(location, with: image)
    }

    func removeLocation(location: Location) {
        guard locations.contains(where: { $0.id == location.id }) else {
            return
        }

        storage.removeLocation(location)
    }

    func updateLocation(updatedLocation: Location) throws {
        guard locations.contains(where: { $0.id == updatedLocation.id }) else {
            return
        }

        try storage.updateLocation(updatedLocation)
    }

}
