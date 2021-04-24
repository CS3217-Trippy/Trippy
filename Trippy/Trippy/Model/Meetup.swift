//
//  Meetup.swift
//  Trippy
//
//  Created by Lim Chun Yong on 12/4/21.
//
import Foundation
import CoreLocation

class Meetup: Model {
    var meetupPrivacy: MeetupPrivacy
    var id: String?
    var userIds: [String]
    var hostUserId: String
    var locationId: String
    var meetupDate: Date
    var dateAdded: Date
    var userDescription: String

    init(id: String?, meetupPrivacy: MeetupPrivacy, userIds: [String],
         hostUserId: String, locationId: String,
         meetupDate: Date, dateAdded: Date,
         userDescription: String) {
        self.meetupPrivacy = meetupPrivacy
        self.id = id
        self.hostUserId = hostUserId
        self.userIds = userIds
        self.locationId = locationId
        self.meetupDate = meetupDate
        self.dateAdded = dateAdded
        self.userDescription = userDescription
    }
}
