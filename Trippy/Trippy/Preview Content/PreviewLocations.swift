//
//  PreviewLocations.swift
//  Trippy
//
//  Created by QL on 13/3/21.
//

import CoreLocation

struct PreviewLocations {
    static let locations = [
        Location(
            id: "0-1",
            coordinates: CLLocationCoordinate2D(latitude: 1.29584, longitude: 103.77340),
            name: "The Lost Palace of Easttown",
            description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. "
        ),
        Location(
            id: "0-2",
            coordinates: CLLocationCoordinate2D(latitude: 1.34440, longitude: 103.68040),
            name: "The great tree of Westtown",
            description: "Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
        ),
        Location(
            id: "0-3",
            coordinates: CLLocationCoordinate2D(latitude: 1.29775, longitude: 103.84950),
            name: "The Obelisk of Centraltown",
            description: "Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
        )
    ]
}
