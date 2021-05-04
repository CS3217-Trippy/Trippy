//
//  HomepageViewModel.swift
//  Trippy
//
//  Created by Audrey Felicio Anwar on 18/3/21.
//

import Combine
import SwiftUI

final class HomepageViewModel: ObservableObject {

    @Published var locationModel: LocationModel<FBStorage<FBLocation>>
    @Published var bucketModel: BucketModel<FBStorage<FBBucketItem>>
    @Published var friendsModel: FriendsListModel<FBStorage<FBFriend>>
    @Published var achievementsModel: AchievementModel<FBStorage<FBAchievement>>
    @Published var meetupModel: MeetupModel<FBStorage<FBMeetup>>
    @Published var itineraryModel: ItineraryModel<FBStorage<FBItineraryItem>>
    @Published var ratingModel: RatingModel<FBStorage<FBRating>>
    @Published var meetupNotificationModel: MeetupNotificationModel<FBStorage<FBMeetupNotification>>
    let userId: String
    let imageModel: ImageModel
    private let visitTracker: VisitTracker
    private let meetupNotificationTracker: MeetupNotificationTracker

    init(session: SessionStore,
         locationCoordinator: LocationCoordinator,
         notificationManager: NotificationManager, showLocationAlert: Binding<Bool>,
         completedLocation: Binding<String>, alertTitle: Binding<String>, alertContent: Binding<String>) {
        userId = session.currentLoggedInUser?.id ?? ""
        let imageStorage = FBImageStorage()
        let imageModel = ImageModel(storage: imageStorage)
        let ratingStorage = FBStorage<FBRating>()
        let ratingModel = RatingModel(storage: ratingStorage)
        self.ratingModel = ratingModel
        self.imageModel = imageModel
        let locationStorage = FBStorage<FBLocation>()
        let locationModel = LocationModel<FBStorage<FBLocation>>(
            storage: locationStorage,
            imageModel: imageModel,
            recommender: FBLocationRecommender(userId: session.currentLoggedInUser?.id))
        self.locationModel = locationModel
        let bucketStorage = FBStorage<FBBucketItem>()
        let bucketModel = BucketModel<FBStorage<FBBucketItem>>(
            storage: bucketStorage,
            userId: session.currentLoggedInUser?.id
        )
        self.bucketModel = bucketModel
        let friendStorage = FBStorage<FBFriend>()
        self.friendsModel = FriendsListModel<FBStorage<FBFriend>>(
            storage: friendStorage,
            userId: session.currentLoggedInUser?.id
        )
        let achievementStorage = FBStorage<FBAchievement>()
        self.achievementsModel = AchievementModel<FBStorage<FBAchievement>>(
            storage: achievementStorage
        )
        visitTracker = VisitTracker(
            locationCoordinator: locationCoordinator, notificationManager: notificationManager,
            locationModel: locationModel, bucketModel: bucketModel,
            showLocationAlert: showLocationAlert, completedLocation: completedLocation,
            alertTitle: alertTitle, alertContent: alertContent,
            levelSystemService: session.levelSystemService, ratingModel: ratingModel
        )

        let meetupStorage = FBStorage<FBMeetup>()
        let meetupModel = MeetupModel<FBStorage<FBMeetup>>(
            storage: meetupStorage,
            userId: session.currentLoggedInUser?.id
        )
        self.meetupModel = meetupModel

        let meetupNotificationStorage = FBStorage<FBMeetupNotification>()
        let meetupNotificationModel = MeetupNotificationModel
        <FBStorage<FBMeetupNotification>>(storage: meetupNotificationStorage,
                                          userId: session.currentLoggedInUser?.id)
        self.meetupNotificationModel = meetupNotificationModel
        self.meetupNotificationTracker = MeetupNotificationTracker(notificationManager: notificationManager,
                                                                   meetupNotificationModel: meetupNotificationModel,
                                                                   meetupModel: meetupModel)

        let itineraryStorage = FBStorage<FBItineraryItem>()
        self.itineraryModel = ItineraryModel<FBStorage<FBItineraryItem>>(
            storage: itineraryStorage, userId: session.currentLoggedInUser?.id
        )
    }
}
