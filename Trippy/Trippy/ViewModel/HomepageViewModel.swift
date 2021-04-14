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
    @Published var ratingModel: RatingModel<FBStorage<FBRating>>
    let imageModel: ImageModel
    private let visitTracker: VisitTracker

    init(session: SessionStore, locationCoordinator: LocationCoordinator, showLocationAlert: Binding<Bool>,
         alertTitle: Binding<String>, alertContent: Binding<String>) {
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
        let friendsModel = FriendsListModel<FBStorage<FBFriend>>(
            storage: friendStorage,
            userId: session.currentLoggedInUser?.id
        )
        self.friendsModel = friendsModel
        visitTracker = VisitTracker(
            locationCoordinator: locationCoordinator,
            locationModel: locationModel,
            bucketModel: bucketModel,
            showLocationAlert: showLocationAlert,
            alertTitle: alertTitle,
            alertContent: alertContent,
            levelSystemService: session.levelSystemService,
            ratingModel: ratingModel
        )
    }
}
