//
//  LocationModel.swift
//  Trippy
//
//  Created by QL on 13/3/21.
//

import Combine
import UIKit

class LocationModel<Storage: ImageSupportedStorage>: ObservableObject where Storage.StoredType == Location {
    @Published private(set) var locations: [Location] = []
    private let storage: Storage
    private var cancellables: Set<AnyCancellable> = []

    init(storage: Storage) {
        self.storage = storage
        storage.storedItems.assign(to: \.locations, on: self)
            .store(in: &cancellables)
        fetchLocations()
    }

    func fetchLocations() {
        storage.fetch()
    }

    func addLocation(location: Location, image: UIImage? = nil) throws {
        guard !locations.contains(where: { $0.id == location.id }) else {
            return
        }

        try storage.add(location, with: image)
    }

    func removeLocation(location: Location) {
        guard locations.contains(where: { $0.id == location.id }) else {
            return
        }

        storage.remove(location)
    }

    func updateLocation(updatedLocation: Location, image: UIImage? = nil) throws {
        guard locations.contains(where: { $0.id == updatedLocation.id }) else {
            return
        }

        try storage.update(updatedLocation, with: image)
    }

}
