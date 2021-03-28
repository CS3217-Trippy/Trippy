//
//  HomepageViewModel.swift
//  Trippy
//
//  Created by Audrey Felicio Anwar on 18/3/21.
//

import Combine

final class HomepageViewModel: ObservableObject {

    @Published var locationModel: LocationModel<FBImageSupportedStorage<FBLocation>>
    @Published var bucketModel: BucketModel<FBUserRelatedStorage<FBBucketItem>>
    @Published var friendsModel: FriendsListModel<FBUserRelatedStorage<FBFriend>>

    init(session: SessionStore) {
        let locationStorage = FBImageSupportedStorage<FBLocation>()

        let locationModel = LocationModel<FBImageSupportedStorage<FBLocation>>(storage: locationStorage)
        self.locationModel = locationModel
        let bucketStorage = FBUserRelatedStorage<FBBucketItem>(userId: session.session?.id)

        let bucketModel = BucketModel<FBUserRelatedStorage<FBBucketItem>>(storage: bucketStorage, userId: session.session?.id)
        self.bucketModel = bucketModel

        let friendStorage = FBUserRelatedStorage<FBFriend>(userId: session.session?.id)
        let friendsModel = FriendsListModel<FBUserRelatedStorage<FBFriend>>(storage: friendStorage, userId: session.session?.id)
        self.friendsModel = friendsModel
    }
}
