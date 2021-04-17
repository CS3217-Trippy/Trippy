import XCTest
import CoreLocation
 @testable import Trippy

 class BucketModelTests: XCTestCase {

    func testInit() throws {
        let storage = MockStorage<FBBucketItem>()
        let userId = "userId"
        let locationId = "1"
        let item = constructBucketItem(locationId: locationId)
        storage.add(item: item)
        let model = BucketModel<MockStorage<FBBucketItem>>(storage: storage, userId: userId)
        let items = model.bucketItems
        XCTAssertEqual(items.count, 1)
    }

    func testAdd() throws {
        let storage = MockStorage<FBBucketItem>()
        let userId = "userId"
        let locationId = "1"
        let item = constructBucketItem(locationId: locationId)

        let model = BucketModel<MockStorage<FBBucketItem>>(storage: storage, userId: userId)
        try model.addBucketItem(bucketItem: item)
        let items = model.bucketItems
        XCTAssertEqual(items.count, 1)
    }

    func testAdd_duplicate_shouldFail() throws {
        let storage = MockStorage<FBBucketItem>()
        let userId = "userId"
        let locationId = "1"
        let item = constructBucketItem(locationId: locationId)

        let model = BucketModel<MockStorage<FBBucketItem>>(storage: storage, userId: userId)
        try model.addBucketItem(bucketItem: item)
        try model.addBucketItem(bucketItem: item)
        let items = model.bucketItems
        XCTAssertEqual(items.count, 1)
    }

    func testUpdate() throws {
        let storage = MockStorage<FBBucketItem>()
        let userId = "userId"
        let locationId = "1"
        let item = constructBucketItem(locationId: locationId)

        let model = BucketModel<MockStorage<FBBucketItem>>(storage: storage, userId: userId)
        try model.addBucketItem(bucketItem: item)
        let newLocationId = "2"
        item.locationId = newLocationId
        try model.updateBucketItem(bucketItem: item)
        let items = model.bucketItems
        XCTAssertEqual(items.count, 1)
        let newItem = model.bucketItems[0]
        XCTAssertEqual(newItem.locationId, newLocationId)
    }

    func testUpdate_itemDoesNotExist_shouldFail() throws {
        let storage = MockStorage<FBBucketItem>()
        let userId = "userId"
        let model = BucketModel<MockStorage<FBBucketItem>>(storage: storage, userId: userId)
        let locationId = "location1"
        let item = constructBucketItem(locationId: locationId)
        let newItem = constructBucketItem(locationId: locationId)
        newItem.id = "newId"
        let oldLocation = item.locationName
        let newLocation = "New location"
        newItem.locationName = newLocation
        try model.addBucketItem(bucketItem: item)
        try model.updateBucketItem(bucketItem: newItem)
        let items = model.bucketItems
        XCTAssertEqual(items.count, 1)
        XCTAssertEqual(model.bucketItems[0].locationName, oldLocation)
    }

    func testRemove() throws {
        let storage = MockStorage<FBBucketItem>()
        let userId = "userId"
        let model = BucketModel<MockStorage<FBBucketItem>>(storage: storage, userId: userId)
        let locationId = "locationId"
        let newItem = constructBucketItem(locationId: locationId)
        try model.addBucketItem(bucketItem: newItem)
        model.removeBucketItem(bucketItem: newItem)
        let items = model.bucketItems
        XCTAssertEqual(items.count, 0)
    }

    func testRemove_itemDoesNotExist_shouldFail() {
        let storage = MockStorage<FBBucketItem>()
        let userId = "userId"
        let model = BucketModel<MockStorage<FBBucketItem>>(storage: storage, userId: userId)
        let locationId = "locationId1"
        let newItem = constructBucketItem(locationId: locationId)
        let items = model.bucketItems
        XCTAssertEqual(items.count, 0)
        model.removeBucketItem(bucketItem: newItem)
        XCTAssertEqual(items.count, 0)
    }

    private func constructBucketItem(locationId: String) -> BucketItem {
        let locationName = "location"
        let userId = "userId"
        let description = "description"
        let dateAdded = Date()
        return BucketItem(locationName: locationName, locationCategory: LocationCategory.adventure,
                          locationImageId: nil,
                          userId: userId,
                          locationId: locationId, dateVisited: nil,
                          dateAdded: dateAdded,
                          userDescription: description,
                          coordinates: CLLocationCoordinate2D(latitude: 0, longitude: 0)
                          )
    }

 }
