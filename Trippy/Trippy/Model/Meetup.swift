//
//  Meetup.swift
//  Trippy
//
//  Created by Lim Chun Yong on 12/4/21.
//
import Foundation
class Meetup: Model {
    var id: String?
    var userIds: [String]
    var userProfilePhotoIds: [String]
    var hostUserId: String
    var locationName: String
    var locationCategory: LocationCategory
    var locationImageId: String?
    var locationId: String
    var meetupDate: Date
    var dateAdded: Date
    var userDescription: String

    init(id: String?,
         userIds: [String],
         userProfilePhotoIds: [String],
         hostUserId: String,
         locationImageId: String?,
         locationName: String,
         locationCategory: LocationCategory,
         locationId: String,
         meetupDate: Date,
         dateAdded: Date,
         userDescription: String) {
        self.id = id
        self.userProfilePhotoIds = userProfilePhotoIds
        self.locationName = locationName
        self.locationCategory = locationCategory
        self.locationImageId = locationImageId
        self.hostUserId = hostUserId
        self.userIds = userIds
        self.locationId = locationId
        self.meetupDate = meetupDate
        self.dateAdded = dateAdded
        self.userDescription = userDescription
    }

}
