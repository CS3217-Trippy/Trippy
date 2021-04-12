import FirebaseFirestoreSwift
import Foundation
import UIKit

struct FBBucketItem: FBStorable {
    typealias ModelType = BucketItem
    static var path = "bucketItems"
    @DocumentID var id: String?
    var locationName: String
    var locationImage: [String] = []
    var userId: String
    var locationId: String
    var dateVisited: Date?
    var locationImageIds: [String] = []
    var dateAdded: Date
    var userDescription: String
    var locationCategory: LocationCategory

    init(item: ModelType) {
        id = item.id
        locationName = item.locationName
        userId = item.userId
        locationId = item.locationId
        dateVisited = item.dateVisited
        dateAdded = item.dateAdded
        userDescription = item.userDescription
        locationCategory = item.locationCategory
        if let imageId = item.locationImageId {
            locationImageIds.append(imageId)
        }
    }

    func convertToModelType() -> ModelType {
        var locationImageId: String?
        if !locationImageIds.isEmpty {
            locationImageId = locationImageIds[0]
        }
        let bucketItem = BucketItem(locationName: locationName,
                                    locationCategory: locationCategory,
                                    locationImageId: locationImageId,
                                    userId: userId,
                                    locationId: locationId,
                                    dateVisited: dateVisited,
                                    dateAdded: dateAdded,
                                    userDescription: userDescription
                  )
        return bucketItem
    }
}
