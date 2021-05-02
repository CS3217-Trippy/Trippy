//
//  LocationPin.swift
//  Trippy
//
//  Created by QL on 16/3/21.
//

import MapKit

class LocationPin: NSObject, MKAnnotation {
    var location: Location

    var coordinate: CLLocationCoordinate2D {
        location.coordinates
    }
    var title: String? {
        location.name
    }
    var subtitle: String? {
        location.placemark?.thoroughfare
    }

    init(location: Location) {
        self.location = location
        super.init()
    }
}
