import FirebaseFirestoreSwift
import Foundation

struct FBBucketItem: Identifiable, Codable {
    @DocumentID var id: String?
    var locationName: String
    var locationImage: String
    var userId: String
    var locationId: String
    var dateVisited: Date?
    var dateAdded: Date
    var userDescription: String
}
