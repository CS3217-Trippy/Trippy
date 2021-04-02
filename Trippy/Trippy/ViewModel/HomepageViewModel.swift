//
//  HomepageViewModel.swift
//  Trippy
//
//  Created by Audrey Felicio Anwar on 18/3/21.
//

import Combine
import SwiftUI

final class HomepageViewModel: ObservableObject {

    @Published var locationModel: LocationModel<FBImageSupportedStorage<FBLocation>>
    @Published var bucketModel: BucketModel<FBUserRelatedStorage<FBBucketItem>>
    @Published var friendsModel: FriendsListModel<FBUserRelatedStorage<FBFriend>>
    private let visitTracker: VisitTracker

    init(session: SessionStore, locationCoordinator: LocationCoordinator, showLocationAlert: Binding<Bool>,
         alertTitle: Binding<String>, alertContent: Binding<String>) {
        let locationStorage = FBImageSupportedStorage<FBLocation>()
        let locationModel = LocationModel<FBImageSupportedStorage<FBLocation>>(
            storage: locationStorage,
            recommender: FBLocationRecommender(userId: session.retrieveCurrentLoggedInUser()?.id))
        self.locationModel = locationModel
        let bucketStorage = FBUserRelatedStorage<FBBucketItem>(userId: session.retrieveCurrentLoggedInUser()?.id)

        let bucketModel = BucketModel<FBUserRelatedStorage<FBBucketItem>>(
            storage: bucketStorage,
            userId: session.retrieveCurrentLoggedInUser()?.id
        )
        self.bucketModel = bucketModel

        let friendStorage = FBUserRelatedStorage<FBFriend>(userId: session.retrieveCurrentLoggedInUser()?.id)
        let friendsModel = FriendsListModel<FBUserRelatedStorage<FBFriend>>(
            storage: friendStorage,
            userId: session.retrieveCurrentLoggedInUser()?.id
        )
        self.friendsModel = friendsModel
        visitTracker = VisitTracker(
            locationCoordinator: locationCoordinator,
            locationModel: locationModel,
            bucketModel: bucketModel,
            showLocationAlert: showLocationAlert,
            alertTitle: alertTitle,
            alertContent: alertContent
        )
    }
}
