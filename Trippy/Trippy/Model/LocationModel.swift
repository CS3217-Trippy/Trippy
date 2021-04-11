//
//  LocationModel.swift
//  Trippy
//
//  Created by QL on 13/3/21.
//

import Combine
import UIKit

class LocationModel<Storage: StorageProtocol>: ObservableObject where Storage.StoredType == Location {
    @Published private(set) var locations: [Location] = []
    @Published private(set) var recommendedLocations: [Location] = []
    private var recommender: LocationRecommender
    private let storage: Storage
    private let imageStorage: ImageStorage
    private var cancellables: Set<AnyCancellable> = []

    init(storage: Storage, imageStorage: ImageStorage, recommender: LocationRecommender) {
        self.imageStorage = imageStorage
        self.storage = storage
        self.recommender = recommender
        recommender.recommendedItems.assign(to: \.recommendedLocations, on: self).store(in: &cancellables)
        storage.storedItems.assign(to: \.locations, on: self)
            .store(in: &cancellables)
        fetchLocations()
    }

    func fetchRecommendedLocations() {
        recommender.fetch()
    }

    func fetchLocations() {
        storage.fetch()
    }

    func addLocation(location: Location, image: UIImage? = nil) throws {
        guard !locations.contains(where: { $0.id == location.id }) else {
            return
        }
        let id = location.imageId
        if let image = image, let id = id {
            let trippyImage = TrippyImage(id: id, image: image)
            imageStorage.add(with: [trippyImage])
        }
        try storage.add(item: location)
    }

    func removeLocation(location: Location) {
        guard locations.contains(where: { $0.id == location.id }) else {
            return
        }
        storage.remove(item: location)
    }

    func updateLocation(updatedLocation: Location, image: UIImage? = nil) throws {
        guard locations.contains(where: { $0.id == updatedLocation.id }) else {
            return
        }
        let id = updatedLocation.imageId
        if let image = image, let id = id {
            let trippyImage = TrippyImage(id: id, image: image)
            imageStorage.add(with: [trippyImage])
        }
        try storage.update(item: updatedLocation)
    }

}
