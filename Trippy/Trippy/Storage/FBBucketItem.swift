import FirebaseFirestoreSwift
import Foundation

struct FBBucketItem: FBUserRelatedStorable {
    typealias ModelType = BucketItem
    static var path = "bucketItems"
    @DocumentID var id: String?
    var locationName: String
    var locationImage: String?
    var userId: String
    var locationId: String
    var dateVisited: Date?
    var dateAdded: Date
    var userDescription: String

    init(item: ModelType) {
        id = item.id
        locationName = item.locationName
        locationImage = item.locationImage?.absoluteString
        userId = item.userId
        locationId = item.locationId
        dateVisited = item.dateVisited
        dateAdded = item.dateAdded
        userDescription = item.userDescription
    }

    func convertToModelType() -> ModelType {
        var image: URL?
        if let url = locationImage {
            image = URL(string: url)
        }
        return BucketItem(locationName: locationName,
                          locationImage: image,
                          userId: userId,
                          locationId: locationId,
                          dateVisited: dateVisited,
                          dateAdded: dateAdded,
                          userDescription: userDescription
        )
    }

}
