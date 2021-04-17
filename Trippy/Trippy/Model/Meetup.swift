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
    var userProfilePhotoIds: [String]
    var hostUsername: String
    var hostUserId: String
    var locationName: String
    var locationCategory: LocationCategory
    var locationImageId: String?
    var locationId: String
    var meetupDate: Date
    var dateAdded: Date
    var userDescription: String
    let coordinates: CLLocationCoordinate2D
    var placemark: CLPlacemark?

    init(id: String?, meetupPrivacy: MeetupPrivacy, userIds: [String],
         userProfilePhotoIds: [String], hostUsername: String, hostUserId: String,
         locationImageId: String?, locationName: String, locationCategory: LocationCategory,
         locationId: String, meetupDate: Date, dateAdded: Date,
         userDescription: String, coordinates: CLLocationCoordinate2D) {
        self.meetupPrivacy = meetupPrivacy
        self.id = id
        self.userProfilePhotoIds = userProfilePhotoIds
        self.locationName = locationName
        self.locationCategory = locationCategory
        self.locationImageId = locationImageId
        self.hostUsername = hostUsername
        self.hostUserId = hostUserId
        self.userIds = userIds
        self.locationId = locationId
        self.meetupDate = meetupDate
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
