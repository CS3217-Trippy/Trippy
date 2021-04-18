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
        let storage = MockStorage<FBLocation>()
        let recommender = MockLocationRecommender()
        let model = LocationModel<MockStorage<FBLocation>>(
            storage: storage,
            imageModel: ImageModel(storage: MockImageStorage()),
            recommender: recommender
        )
        XCTAssertEqual(model.locations.count, 0)
    }

    func testAdd_valid() throws {
        let storage = MockStorage<FBLocation>()
        let recommender = MockLocationRecommender()
        let model = LocationModel<MockStorage<FBLocation>>(
            storage: storage,
            imageModel: ImageModel(storage: MockImageStorage()),
            recommender: recommender
        )
        let originalCount = model.locations.count
        let newLocation = Location(
            id: "1204A",
            coordinates: CLLocationCoordinate2D(latitude: 23, longitude: 123),
            name: "lorem",
            description: "ipsum",
            category: .adventure,
            imageId: "01"
        )
        try model.addLocation(location: newLocation)
        XCTAssertEqual(model.locations.count, originalCount + 1)
        XCTAssertTrue(model.locations.contains(where: { $0 === newLocation }))
    }

    func testRemove_valid() throws {
        let storage = MockStorage<FBLocation>()
        let recommender = MockLocationRecommender()
        let model = LocationModel<MockStorage<FBLocation>>(
            storage: storage,
            imageModel: ImageModel(storage: MockImageStorage()),
            recommender: recommender
        )
        let newLocation = Location(
            id: "1204A",
            coordinates: CLLocationCoordinate2D(latitude: 23, longitude: 123),
            name: "lorem",
            description: "ipsum",
            category: .adventure,
            imageId: "02"
        )
        try model.addLocation(location: newLocation)

        let originalCount = model.locations.count
        let toBeRemoved = model.locations[0]
        model.removeLocation(location: toBeRemoved)
        XCTAssertEqual(model.locations.count, originalCount - 1)
        XCTAssertFalse(model.locations.contains(where: { $0 === toBeRemoved }))
    }

    func testRemove_locationDoesNotExist() {
        let storage = MockStorage<FBLocation>()
        let recommender = MockLocationRecommender()
        let model = LocationModel<MockStorage<FBLocation>>(
            storage: storage,
            imageModel: ImageModel(storage: MockImageStorage()),
            recommender: recommender
        )
        let originalCount = model.locations.count
        let newLocation = Location(
            id: "12414ABC",
            coordinates: CLLocationCoordinate2D(latitude: 23, longitude: 123),
            name: "lorem",
            description: "ipsum",
            category: .nature,
            imageId: "0A"
        )
        model.removeLocation(location: newLocation)
        XCTAssertEqual(model.locations.count, originalCount)
    }

    func testUpdate_valid() throws {
        let storage = MockStorage<FBLocation>()
        let recommender = MockLocationRecommender()
        let model = LocationModel<MockStorage<FBLocation>>(
            storage: storage,
            imageModel: ImageModel(storage: MockImageStorage()),
            recommender: recommender
        )
        let newLocation = Location(
            id: "1204A",
            coordinates: CLLocationCoordinate2D(latitude: 23, longitude: 123),
            name: "lorem",
            description: "ipsum",
            category: .adventure,
            imageId: "201"
        )
        try model.addLocation(location: newLocation)

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

    func testUpdate_locationDoesNotExist() throws {
        let storage = MockStorage<FBLocation>()
        let recommender = MockLocationRecommender()
        let model = LocationModel<MockStorage<FBLocation>>(
            storage: storage,
            imageModel: ImageModel(storage: MockImageStorage()),
            recommender: recommender
        )
        let originalCount = model.locations.count
        let newLocation = Location(
            id: "12414ABC",
            coordinates: CLLocationCoordinate2D(latitude: 23, longitude: 123),
            name: "lorem",
            description: "ipsum",
            category: .resort,
            imageId: "sdf"
        )
        try model.updateLocation(updatedLocation: newLocation)
        XCTAssertEqual(model.locations.count, originalCount)
        XCTAssertFalse(model.locations.contains(where: { $0.id == newLocation.id }))
    }
 }
