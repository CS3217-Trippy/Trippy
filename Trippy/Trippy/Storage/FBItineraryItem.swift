import FirebaseFirestoreSwift
import Foundation
import CoreLocation

/**
 Storage representation of an itinerary item.
 */
struct FBItineraryItem: FBStorable {
    typealias ModelType = ItineraryItem
    static var path = "itineraryItems"
    @DocumentID var id: String?
    var locationName: String
    var locationImage: [String] = []
    var latitude: Double
    var longitude: Double
    var userId: String
    var locationId: String
    var locationImageIds: [String] = []

    init(item: ModelType) {
        id = item.id
        locationName = item.locationName
        userId = item.userId
        locationId = item.locationId
        latitude = item.coordinates.latitude
        longitude = item.coordinates.longitude
        if let imageId = item.locationImageId {
            locationImageIds.append(imageId)
        }
    }

    func convertToModelType() -> ModelType {
        var locationImageId: String?
        if !locationImageIds.isEmpty {
            locationImageId = locationImageIds[0]
        }
        let itineraryItem = ItineraryItem(locationName: locationName,
                                          locationImageId: locationImageId,
                                          userId: userId,
                                          locationId: locationId,
                                          coordinates: CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                  )
        return itineraryItem
    }
}
