//
//  Meetup.swift
//  Trippy
//
//  Created by Lim Chun Yong on 12/4/21.
//
import Foundation
import CoreLocation

class MeetupNotification: Model {
    var id: String?
    var meetupId: String
    var userId: String
    var isNotified: Bool

    init(meetupId: String, userId: String, isNotified: Bool) {
        self.id = meetupId + userId
        self.meetupId = meetupId
        self.userId = userId
        self.isNotified = isNotified
    }
}
