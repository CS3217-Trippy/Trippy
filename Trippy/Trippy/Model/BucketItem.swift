import Foundation
class BucketItem: UserRelatedModel {
    var id: String?
    var locationName: String
    var locationCategory: LocationCategory
    var locationImage: URL?
    var userId: String
    var locationId: String
    var dateVisited: Date?
    var dateAdded: Date
    var userDescription: String

    init(locationName: String, locationCategory: LocationCategory, locationImage: URL?,
         userId: String, locationId: String, dateVisited: Date?, dateAdded: Date, userDescription: String) {
        self.id = userId + locationId
        self.locationName = locationName
        self.locationCategory = locationCategory
        self.locationImage = locationImage
        self.userId = userId
        self.locationId = locationId
        self.dateVisited = dateVisited
        self.dateAdded = dateAdded
        self.userDescription = userDescription
    }
}
