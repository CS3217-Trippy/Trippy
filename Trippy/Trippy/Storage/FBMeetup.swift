import FirebaseFirestoreSwift
import Foundation
import CoreLocation

struct FBMeetup: FBStorable {
    typealias ModelType = Meetup
    static var path = "meetups"
    var meetupPrivacy: MeetupPrivacy
    @DocumentID var id: String?
    var userIds: [String]
    var hostUsername: String
    var hostUserId: String
    var locationName: String
    var userProfilePhotoIds: [String]
    var locationCategory: LocationCategory
    var locationImageIds: [String] = []
    var locationId: String
    var meetupDate: Date
    var dateAdded: Date
    var userDescription: String
    var latitude: Double
    var longitude: Double

    init(item: ModelType) {
        self.meetupPrivacy = item.meetupPrivacy
        self.id = item.id
        self.userIds = item.userIds
        self.userProfilePhotoIds = item.userProfilePhotoIds
        self.hostUsername = item.hostUsername
        self.hostUserId = item.hostUserId
        self.locationName = item.locationName
        self.locationCategory = item.locationCategory
        self.locationId = item.locationId
        self.meetupDate = item.meetupDate
        self.dateAdded = item.dateAdded
        self.userDescription = item.userDescription
        if let imageId = item.locationImageId {
            locationImageIds.append(imageId)
        }
        self.latitude = item.coordinates.latitude
        self.longitude = item.coordinates.longitude
    }

    func convertToModelType() -> Meetup {
        var locationImageId: String?
        if !locationImageIds.isEmpty {
            locationImageId = locationImageIds[0]
        }
        let meetup = Meetup(id: id,
                            meetupPrivacy: meetupPrivacy,
                            userIds: userIds,
                            userProfilePhotoIds: userProfilePhotoIds,
                            hostUsername: hostUsername,
                            hostUserId: hostUserId,
                            locationImageId: locationImageId,
                            locationName: locationName,
                            locationCategory: locationCategory,
                            locationId: locationId,
                            meetupDate: meetupDate,
                            dateAdded: dateAdded,
                            userDescription: userDescription,
                            coordinates: CLLocationCoordinate2D(latitude: latitude, longitude: longitude))
        return meetup
    }
}
