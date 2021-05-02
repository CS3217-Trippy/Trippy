import FirebaseFirestoreSwift
import Foundation
import CoreLocation

/// Storage representation of an itinerary item.
struct FBItineraryItem: FBStorable {
    typealias ModelType = ItineraryItem
    static var path = "itineraryItems"
    @DocumentID var id: String?
    var userId: String
    var locationId: String

    init(item: ModelType) {
        id = item.id
        userId = item.userId
        locationId = item.locationId
    }

    func convertToModelType() -> ModelType {
        let itineraryItem = ItineraryItem(
            userId: userId,
            locationId: locationId
        )
        return itineraryItem
    }
}
