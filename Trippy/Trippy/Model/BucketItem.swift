import Foundation
import UIKit

class BucketItem: Model {
    var id: String?
    var locationName: String
    var locationCategory: LocationCategory
    var userId: String
    var locationId: String
    var dateVisited: Date?
    var dateAdded: Date
    var locationImageId: String?
    var userDescription: String

    init(locationName: String,
         locationCategory: LocationCategory,
         locationImageId: String?,
         userId: String,
         locationId: String,
         dateVisited: Date?,
         dateAdded: Date,
         userDescription: String) {
        self.id = userId + locationId
        self.locationName = locationName
        self.locationCategory = locationCategory
        self.locationImageId = locationImageId
        self.userId = userId
        self.locationId = locationId
        self.dateVisited = dateVisited
        self.dateAdded = dateAdded
        self.userDescription = userDescription
    }
}
