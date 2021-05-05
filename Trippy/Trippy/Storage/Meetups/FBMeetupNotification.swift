//
//  FBChatMessage.swift
//  Trippy
//
//  Created by Lim Chun Yong on 2/5/21.
//
import FirebaseFirestoreSwift
import Foundation
import CoreLocation

struct FBMeetupNotification: FBStorable {
    static var path = "meetupNotifications"
    typealias ModelType = MeetupNotification
    @DocumentID var id: String?
    var meetupId: String
    var userId: String
    var isNotified: Bool

    init(item: ModelType) {
        id = item.id
        meetupId = item.meetupId
        userId = item.userId
        isNotified = item.isNotified
    }

    func convertToModelType() -> MeetupNotification {
        MeetupNotification(meetupId: meetupId, userId: userId, isNotified: isNotified)
    }
}
