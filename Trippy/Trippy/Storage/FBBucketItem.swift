import FirebaseFirestoreSwift
import Foundation
import UIKit

struct FBBucketItem: FBUserRelatedStorable {
    typealias ModelType = BucketItem
    static var path = "bucketItems"
    @DocumentID var id: String?
    var locationName: String
    var locationImage: [String] = []
    var userId: String
    var locationId: String
    var dateVisited: Date?
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
    }

    func convertToModelType() -> ModelType {
        let bucketItem = BucketItem(locationName: locationName,
                                    locationCategory: locationCategory,
                                    userId: userId,
                                    locationId: locationId,
                                    dateVisited: dateVisited,
                                    dateAdded: dateAdded,
                                    userDescription: userDescription
                  )
        if !locationImage.isEmpty {
            Downloader.getDataFromString(from: locationImage[0]) { data, _, error in
                guard let data = data, error == nil else {
                    return
                }
                let image = UIImage(data: data)
                bucketItem.locationImage = image
            }
        }
        return bucketItem
    }
}
