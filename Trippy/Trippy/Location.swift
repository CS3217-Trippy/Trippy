//
//  Location.swift
//  Trippy
//
//  Created by QL on 10/3/21.
//

import CoreLocation

class Location: Identifiable {
    var id: String?
    var coordinates: CLLocationCoordinate2D
    var name: String
    var description: String
    
    init(id: String?, coordinates: CLLocationCoordinate2D, name: String, description: String) {
        self.id = id
        self.coordinates = coordinates
        self.name = name
        self.description = description
    }
}
