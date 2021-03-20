import XCTest
@testable import Trippy

class BucketModelTests: XCTestCase {

    func testInit() {
        let storage = MockBucketStorage()
        let model = BucketModel(storage: storage)
        let items = model.bucketItems
        XCTAssertEqual(items.count, 1)
    }

    func testAdd() {
        let storage = MockBucketStorage()
        let model = BucketModel(storage: storage)
        let locationId = "tokyo"
        let item = constructBucketItem(locationId: locationId)
        do {
            try model.addBucketItem(bucketItem: item)
        } catch {
            fatalError("should be able to add bucket item")
        }
        let items = model.bucketItems
        XCTAssertEqual(items.count, 2)
    }

    func testAdd_duplicate_shouldFail() {
        let storage = MockBucketStorage()
        let model = BucketModel(storage: storage)
        let item = model.bucketItems[0]
        do {
            try model.addBucketItem(bucketItem: item)
        } catch {
            fatalError("should be able to add bucket item")
        }
        let items = model.bucketItems
        XCTAssertEqual(items.count, 1)
    }

    func testUpdate() {
        let storage = MockBucketStorage()
        let model = BucketModel(storage: storage)
        let locationId = "location1"
        let item = constructBucketItem(locationId: locationId)
        let newItem = item
        let newLocation = "New location"
        newItem.locationName = newLocation
        do {
            try model.addBucketItem(bucketItem: item)
            try model.updateBucketItem(bucketItem: newItem)
            let items = model.bucketItems
            XCTAssertEqual(items.count, 2)
        } catch {
            fatalError("Should be able to update bucket item")
        }
    }

    func testUpdate_itemDoesNotExist_shouldFail() {
        let storage = MockBucketStorage()
        let model = BucketModel(storage: storage)
        let locationId = "location1"
        let item = constructBucketItem(locationId: locationId)
        let newItem = constructBucketItem(locationId: locationId)
        newItem.id = "newId"
        let oldLocation = item.locationName
        let newLocation = "New location"
        newItem.locationName = newLocation
        do {
            try model.addBucketItem(bucketItem: item)
            try model.updateBucketItem(bucketItem: newItem)
        } catch {
            fatalError("Should be able to update bucket item")
        }
        let items = model.bucketItems
        XCTAssertEqual(items.count, 2)
        XCTAssertEqual(model.bucketItems[1].locationName, oldLocation)
    }

    func testRemove() {
        let storage = MockBucketStorage()
        let model = BucketModel(storage: storage)
        let locationId = "locationId"
        let newItem = constructBucketItem(locationId: locationId)
        model.removeBucketItem(bucketItem: newItem)
        let items = model.bucketItems
        XCTAssertEqual(items.count, 0)
    }

    func testRemove_itemDoesNotExist_shouldFail() {
        let storage = MockBucketStorage()
        let model = BucketModel(storage: storage)
        let locationId = "locationId1"
        let newItem = constructBucketItem(locationId: locationId)
        let items = model.bucketItems
        XCTAssertEqual(items.count, 1)
        model.removeBucketItem(bucketItem: newItem)
        XCTAssertEqual(items.count, 1)
    }

    private func constructBucketItem(locationId: String) -> BucketItem {
        let locationName = "location"
        let locationImage = "image"
        let userId = "userId"
        let description = "description"
        let dateAdded = Date()
        return BucketItem(locationName: locationName,
                          locationImage: locationImage,
                          userId: userId,
                          locationId: locationId, dateVisited: nil,
                          dateAdded: dateAdded,
                          userDescription: description
                          )
    }

}
