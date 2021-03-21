//
//  LocationModelTests.swift
//  TrippyTests
//
//  Created by QL on 19/3/21.
//

import CoreLocation
import Combine
import UIKit
@testable import Trippy

final class MockLocationStorage: LocationStorage, ObservableObject {
    var locations: Published<[Location]>.Publisher {
        $_locations
    }
    @Published private var _locations: [Location] = PreviewLocations.locations

    func fetchLocations() {
        // Assume that a location was removed from the database by someone else (if there are locations to remove)
        if !_locations.isEmpty {
            _locations.remove(at: 0)
        }
    }

    func addLocation(_ location: Location, with image: UIImage?) throws {
        _locations.append(location)
    }

    func updateLocation(_ location: Location) throws {
        _locations.removeAll { $0.id == location.id }
        _locations.append(location)
    }

    func removeLocation(_ location: Location) {
        _locations.removeAll { $0.id == location.id }
    }
}
