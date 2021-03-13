//
//  PreviewLocationStorage.swift
//  Trippy
//
//  Created by QL on 13/3/21.
//

import CoreLocation

class PreviewLocationStorage: LocationStorage {
    func getLocations() -> [Location] {
        return PreviewLocations.locations
    }
    
    func addLocation(_ location: Location) throws {
        // Does Nothing
        return
    }
    
    func updateLocation(_ location: Location) throws {
        // Does Nothing
        return
    }
    
    func removeLocation(_ location: Location) {
        // Does Nothing
        return
    }
}
