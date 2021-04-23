import Foundation
import CoreLocation

class BucketItem: Model {
    var id: String?
    let userId: String
    var locationId: String
    var dateVisited: Date?
    let dateAdded: Date
    let userDescription: String

    init(userId: String,
         locationId: String,
         dateVisited: Date?,
         dateAdded: Date,
         userDescription: String) {
        self.id = userId + locationId
        self.userId = userId
        self.locationId = locationId
        self.dateVisited = dateVisited
        self.dateAdded = dateAdded
        self.userDescription = userDescription
    }
}
