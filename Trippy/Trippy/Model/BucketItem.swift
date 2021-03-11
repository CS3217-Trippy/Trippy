import Foundation
import FirebaseFirestoreSwift

struct BucketItem: Identifiable, Codable {
    @DocumentID var id: String?
    var locationName: String
    var locationId: String
    var visited: Bool
}
