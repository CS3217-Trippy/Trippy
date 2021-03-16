import Foundation
import FirebaseFirestoreSwift

struct BucketItem: Identifiable, Codable {
    var id: String
    var locationName: String
    var locationImage: String
    var userId: String
    var locationId: String
    var dateVisited: Date?
    var dateAdded: Date
}
