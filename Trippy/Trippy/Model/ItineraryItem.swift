import Foundation
import CoreLocation

/// Model representation of an itinerary item.
class ItineraryItem: Model {
    var id: String?
    let userId: String
    let locationId: String

    init(
         userId: String,
         locationId: String
    ) {
        self.id = userId + locationId
        self.userId = userId
        self.locationId = locationId
    }
}
