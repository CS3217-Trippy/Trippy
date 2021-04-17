import Foundation
import CoreLocation

class BucketItem: Model {
    var id: String?
    let locationName: String
    let locationCategory: LocationCategory
    let userId: String
    let locationId: String
    var dateVisited: Date?
    let dateAdded: Date
    let locationImageId: String?
    let userDescription: String
    let coordinates: CLLocationCoordinate2D
    var placemark: CLPlacemark?

    init(locationName: String,
         locationCategory: LocationCategory,
         locationImageId: String?,
         userId: String,
         locationId: String,
         dateVisited: Date?,
         dateAdded: Date,
         userDescription: String,
         coordinates: CLLocationCoordinate2D) {
        self.id = userId + locationId
        self.locationName = locationName
        self.locationCategory = locationCategory
        self.locationImageId = locationImageId
        self.userId = userId
        self.locationId = locationId
        self.dateVisited = dateVisited
        self.dateAdded = dateAdded
        self.userDescription = userDescription
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
