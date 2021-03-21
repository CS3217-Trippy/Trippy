//
//  Location.swift
//  Trippy
//
//  Created by QL on 10/3/21.
//

import CoreLocation
import UIKit

class Location: Identifiable {
    let coordinates: CLLocationCoordinate2D
    var id: String?
    var name: String
    var description: String
    var imageURL: URL?
    var placemark: CLPlacemark?
    var image = "https://www.erikastravels.com/wp-content/uploads/2015/11/Lake-Moraine-in-Banff-Canada.jpg"

    init(id: String?, coordinates: CLLocationCoordinate2D, name: String,
         description: String, imageURL: URL? = nil) {
        self.id = id
        self.coordinates = coordinates
        self.name = name
        self.description = description
        self.imageURL = imageURL
        let location = CLLocation(latitude: coordinates.latitude, longitude: coordinates.longitude)
        CLGeocoder().reverseGeocodeLocation(location) { placemark, error in
            guard let placemark = placemark?.first, error == nil else {
                print("Unable to retrieve placemark")
                return
            }
            self.placemark = placemark
        }
    }
}
