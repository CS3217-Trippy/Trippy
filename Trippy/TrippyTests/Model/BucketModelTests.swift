import XCTest
@testable import Trippy

class BucketModelTests: XCTestCase {

    func testGet() {
        let storage = MockBucketStorage()
        let model = BucketModel(storage: storage)
        let items = model.bucketItems
        XCTAssertEqual(items.count, 1)
    }

    func testAdd() {
        let storage = MockBucketStorage()
        let model = BucketModel(storage: storage)
        let newItem = constructBucketItem(id: "newId")
        do {
            try model.addBucketItem(bucketItem: newItem)
            let items = model.bucketItems
            XCTAssertEqual(items.count, 2)
        } catch {
            fatalError("Should be able to add bucket item")
        }
    }

    func testUpdate() {
        let storage = MockBucketStorage()
        let model = BucketModel(storage: storage)
        let item = constructBucketItem(id: "newId")
        var newItem = constructBucketItem(id: "newId")
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

    func testRemove() {
        let storage = MockBucketStorage()
        let model = BucketModel(storage: storage)
        let newItem = constructBucketItem(id: "mockId")
        model.removeBucketItem(bucketItem: newItem)
        let items = model.bucketItems
        XCTAssertEqual(items.count, 0)
    }

    private func constructBucketItem(id: String) -> BucketItem {
        let locationName = "location"
        let locationImage = "image"
        let userId = "userId"
        let locationId = "locationId"
        let dateAdded = Date()
        return BucketItem(id: id,
                          locationName: locationName,
                          locationImage: locationImage,
                          userId: userId,
                          locationId: locationId,
                          dateAdded: dateAdded)
    }

}
