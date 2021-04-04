 import Foundation
 @testable import Trippy

 final class MockBucketStorage: BucketListStorage, ObservableObject {
    @Published var bucketItems: [BucketItem] = []
    private var databaseItems: [BucketItem] = []

    init() {
        fetchBucketItems()
    }

    func fetchBucketItems() {
        let locationName = "location"
        let userId = "userId"
        let locationId = "locationId"
        let description = "description"
        let dateAdded = Date()
        let bucketItem = BucketItem(locationName: locationName,
                                    locationImage: nil,
                                    userId: userId,
                                    locationId: locationId, dateVisited: nil,
                                    dateAdded: dateAdded,
                                    userDescription: description)
        databaseItems = [bucketItem]
        bucketItems = databaseItems
    }

    func addBucketItem(bucketItem: BucketItem) throws {
        databaseItems.append(bucketItem)
        bucketItems = databaseItems
    }

    func updateBucketItem(bucketItem: BucketItem) throws {
        databaseItems = bucketItems.map {item in
            if item.id == bucketItem.id {
                return bucketItem
            }
            return item
        }
        bucketItems = databaseItems
    }

    func removeBucketItem(bucketItem: BucketItem) {
        databaseItems.removeAll { $0.id == bucketItem.id }
        bucketItems = databaseItems
    }

    var bucketList: Published<[BucketItem]>.Publisher {
        $bucketItems
    }
 }
