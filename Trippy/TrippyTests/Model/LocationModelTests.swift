//
//  LocationModelTests.swift
//  TrippyTests
//
//  Created by QL on 19/3/21.
//

import XCTest
import CoreLocation
@testable import Trippy

class LocationModelTests: XCTestCase {

    func testInit() {
        let storage = MockLocationStorage()
        let model = LocationModel(storage: storage)
        XCTAssertEqual(model.locations.count, 3)
    }

    func testFetch() {
        let storage = MockLocationStorage()
        let model = LocationModel(storage: storage)
        let originalCount = model.locations.count
        // Assume someone else removes a location from the database and the client decides to fetch the model again
        model.fetchLocations()
        XCTAssertEqual(model.locations.count, originalCount - 1)
    }

    func testAdd() throws {
        let storage = MockLocationStorage()
        let model = LocationModel(storage: storage)
        let originalCount = model.locations.count
        let newLocation = Location(
            id: "1204A",
            coordinates: CLLocationCoordinate2D(latitude: 23, longitude: 123),
            name: "lorem",
            description: "ipsum"
        )
        try storage.addLocation(newLocation)
        XCTAssertEqual(model.locations.count, originalCount + 1)
        XCTAssertTrue(model.locations.contains(where: { $0 === newLocation }))
    }

    func testRemove() {
        let storage = MockLocationStorage()
        let model = LocationModel(storage: storage)
        let originalCount = model.locations.count
        let toBeRemoved = model.locations[0]
        model.removeLocation(location: toBeRemoved)
        XCTAssertEqual(model.locations.count, originalCount - 1)
        XCTAssertFalse(model.locations.contains(where: { $0 === toBeRemoved }))
    }

    func testUpdate() throws {
        let storage = MockLocationStorage()
        let model = LocationModel(storage: storage)
        let originalCount = model.locations.count
        let toUpdate = model.locations[0]
        let newDescription = "new description"
        model.locations[0].description = newDescription
        try model.updateLocation(updatedLocation: toUpdate)
        XCTAssertEqual(model.locations.count, originalCount)
        guard let updatedLocation = model.locations.first(where: { $0.id == toUpdate.id }) else {
            XCTFail("the updated location should be inside the model")
            return
        }
        XCTAssertEqual(updatedLocation.description, newDescription)
    }
}
