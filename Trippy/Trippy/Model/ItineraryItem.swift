/**
 Model representation of an itinerary item.
 */
import Foundation
import CoreLocation

class ItineraryItem: Model {
    var id: String?
    let locationName: String
    let userId: String
    let locationId: String
    let locationImageId: String?
    let coordinates: CLLocationCoordinate2D
    var placemark: CLPlacemark?

    init(locationName: String,
         locationImageId: String?,
         userId: String,
         locationId: String,
         coordinates: CLLocationCoordinate2D) {
        self.id = userId + locationId
        self.locationName = locationName
        self.locationImageId = locationImageId
        self.userId = userId
        self.locationId = locationId
        self.coordinates = coordinates
        let location = CLLocation(latitude: coordinates.latitude, longitude: coordinates.longitude)
        CLGeocoder().reverseGeocodeLocation(location) { placemark, error in
            guard let placemark = placemark?.first, error == nil else {
                print("Unable to retrieve placemark")
                return
            }
            self.placemark = placemark
        }
    }
}
