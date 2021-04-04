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
            coordinates: CLLocationCoordinate2D(latitude: 1.295_84, longitude: 103.773_40),
            name: "The Lost Palace of Easttown",
            description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor"
                +
                "incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud"
                +
                "exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. ",
            category: LocationCategory.adventure
        ),
        Location(
            id: "0-2",
            coordinates: CLLocationCoordinate2D(latitude: 1.344_40, longitude: 103.680_40),
            name: "The great tree",
            description: "Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore" +
                "eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa" +
                "qui officia deserunt mollit anim id est laborum.", category: LocationCategory.adventure
        ),
        Location(
            id: "0-3",
            coordinates: CLLocationCoordinate2D(latitude: 1.297_75, longitude: 103.849_50),
            name: "The Obelisk of Centraltown",
            description: "Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore" +
                "eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa" +
                "qui officia deserunt mollit anim id est laborum.", category: LocationCategory.adventure
        ),
        Location(
            id: "0-4",
            coordinates: CLLocationCoordinate2D(latitude: 1.257_35, longitude: 103.823_78),
            name: "Tower of the South",
            description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor" +
                "incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud" +
                "exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. ",
            category: LocationCategory.adventure
        )
    ]
}
