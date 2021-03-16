import Foundation
@testable import Trippy

final class MockBucketStorage: BucketListStorage, ObservableObject {
    @Published var bucketItems: [BucketItem] = []
    private var databaseItems: [BucketItem] = []

    init() {
        getBucketItems()
    }

    func getBucketItems() {
        let id = "mockId"
        let locationName = "location"
        let locationImage = "image"
        let userId = "userId"
        let locationId = "locationId"
        let dateAdded = Date()
        let bucketItem = BucketItem(id: id,
                                    locationName: locationName,
                                    locationImage: locationImage,
                                    userId: userId,
                                    locationId: locationId,
                                    dateAdded: dateAdded)
        databaseItems = [bucketItem]
        bucketItems = databaseItems
    }

    func addBucketItem(bucketItem: BucketItem) throws {
        databaseItems.append(bucketItem)
    }

    func updateBucketItem(bucketItem: BucketItem) throws {
        databaseItems = bucketItems.map {item in
            if item.id == bucketItem.id {
                return bucketItem
            }
            return item
        }
    }

    func removeBucketItem(bucketItem: BucketItem) {
        databaseItems.removeAll { $0.id == bucketItem.id }
    }

    var bucketList: Published<[BucketItem]>.Publisher {
        $bucketItems
    }
}
