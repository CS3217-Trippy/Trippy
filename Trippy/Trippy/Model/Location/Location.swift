//
//  Location.swift
//  Trippy
//
//  Created by QL on 10/3/21.
//

import CoreLocation

class Location: Model {
    let coordinates: CLLocationCoordinate2D
    var id: String?
    var name: String
    var description: String
    var placemark: CLPlacemark?
    var category: LocationCategory
    var imageId: String?

    init(id: String?, coordinates: CLLocationCoordinate2D, name: String,
         description: String, category: LocationCategory, imageId: String?) {
        self.id = id
        self.coordinates = coordinates
        self.name = name
        self.imageId = imageId
        self.description = description
        self.category = category
        let location = CLLocation(latitude: coordinates.latitude, longitude: coordinates.longitude)
        CLGeocoder().reverseGeocodeLocation(location) { placemark, error in
            guard let placemark = placemark?.first, error == nil else {
                return
            }
            self.placemark = placemark
        }
    }

}
