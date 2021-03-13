//
//  LocationModel.swift
//  Trippy
//
//  Created by QL on 13/3/21.
//

import Combine

class LocationModel: ObservableObject {
    @Published private(set) var locations: [Location]
    private let storage: LocationStorage
    
    init(storage: LocationStorage) {
        self.storage = storage
        locations = storage.getLocations()
    }
    
    func addLocation(location: Location) throws {
        try storage.addLocation(location)
        locations.append(location)
    }
    
    func removeLocation(location: Location) {
        storage.removeLocation(location)
        locations.removeAll { $0.id == location.id }
    }
    
    func updateLocation(updatedLocation: Location) throws {
        try storage.updateLocation(updatedLocation)
        locations.removeAll { $0.id == updatedLocation.id }
        locations.append(updatedLocation)
    }
}
