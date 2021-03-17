//
//  LocationModel.swift
//  Trippy
//
//  Created by QL on 13/3/21.
//

import Combine

class LocationModel: ObservableObject {
    @Published private(set) var locations: [Location] = []
    private let storage: LocationStorage
    private var cancellables: Set<AnyCancellable> = []
    
    init(storage: LocationStorage) {
        self.storage = storage
        storage.locations.assign(to: \.locations, on: self)
            .store(in: &cancellables)
        storage.fetchLocations()
    }
    
    func addLocation(location: Location) throws {
        try storage.addLocation(location)
    }
    
    func removeLocation(location: Location) {
        storage.removeLocation(location)
    }
    
    func updateLocation(updatedLocation: Location) throws {
        try storage.updateLocation(updatedLocation)
    }
    
}
