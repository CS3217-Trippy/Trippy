import Foundation
import FirebaseFirestoreSwift

class BucketItem: UserRelatedModel {
    var id: String?
    var locationName: String
    var locationImage: URL?
    var userId: String
    var locationId: String
    var dateVisited: Date?
    var dateAdded: Date
    var userDescription: String

    init(locationName: String, locationImage: URL?, userId: String, locationId: String,
         dateVisited: Date?, dateAdded: Date, userDescription: String) {
        self.id = userId + locationId
        self.locationName = locationName
        self.locationImage = locationImage
        self.userId = userId
        self.locationId = locationId
        self.dateVisited = dateVisited
        self.dateAdded = dateAdded
        self.userDescription = userDescription
    }
}
