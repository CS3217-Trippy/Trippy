//
//  PreviewLocationStorage.swift
//  Trippy
//
//  Created by QL on 13/3/21.
//

import CoreLocation
import Combine

class PreviewLocationStorage: LocationStorage {
    var locations: Published<[Location]>.Publisher {
        $_locations
    }
    
    @Published private var _locations:[Location] = []
    
    func fetchLocations() {
        _locations = PreviewLocations.locations
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
