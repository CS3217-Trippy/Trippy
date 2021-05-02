import FirebaseFirestoreSwift
import Foundation
import CoreLocation

struct FBMeetup: FBStorable {
    typealias ModelType = Meetup
    static var path = "meetups"
    var meetupPrivacy: MeetupPrivacy
    @DocumentID var id: String?
    var userIds: [String]
    var hostUserId: String
    var locationId: String
    var meetupDate: Date
    var dateAdded: Date
    var userDescription: String
    init(item: ModelType) {
        self.meetupPrivacy = item.meetupPrivacy
        self.id = item.id
        self.userIds = item.userIds
        self.hostUserId = item.hostUserId
        self.locationId = item.locationId
        self.meetupDate = item.meetupDate
        self.dateAdded = item.dateAdded
        self.userDescription = item.userDescription
    }

    func convertToModelType() -> Meetup {
        let meetup = Meetup(id: id,
                            meetupPrivacy: meetupPrivacy,
                            userIds: userIds,
                            hostUserId: hostUserId,
                            locationId: locationId,
                            meetupDate: meetupDate,
                            dateAdded: dateAdded,
                            userDescription: userDescription)
        return meetup
    }
}
