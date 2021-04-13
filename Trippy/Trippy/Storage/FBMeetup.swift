import FirebaseFirestoreSwift
import Foundation

struct FBMeetup: FBStorable {
    typealias ModelType = Meetup
    static var path = "meetups"
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

    init(item: ModelType) {
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
    }

    func convertToModelType() -> Meetup {
        var locationImageId: String?
        if !locationImageIds.isEmpty {
            locationImageId = locationImageIds[0]
        }
        let meetup = Meetup(id: id,
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
                            userDescription: userDescription)
        return meetup
    }
}
