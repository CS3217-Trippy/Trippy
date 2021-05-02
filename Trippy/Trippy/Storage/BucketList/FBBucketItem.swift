import FirebaseFirestoreSwift
import Foundation
import CoreLocation

struct FBBucketItem: FBStorable {
    typealias ModelType = BucketItem
    static var path = "bucketItems"
    @DocumentID var id: String?
    var userId: String
    var locationId: String
    var dateVisited: Date?
    var dateAdded: Date
    var userDescription: String

    init(item: ModelType) {
        id = item.id
        userId = item.userId
        locationId = item.locationId
        dateVisited = item.dateVisited
        dateAdded = item.dateAdded
        userDescription = item.userDescription
    }

    func convertToModelType() -> ModelType {
        let bucketItem = BucketItem(userId: userId,
                                    locationId: locationId,
                                    dateVisited: dateVisited,
                                    dateAdded: dateAdded,
                                    userDescription: userDescription)
        return bucketItem
    }
}
