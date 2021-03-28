//
//  HomepageViewModel.swift
//  Trippy
//
//  Created by Audrey Felicio Anwar on 18/3/21.
//

import Combine

final class HomepageViewModel: ObservableObject {
    @Published var locationStorage: FBImageSupportedStorage<FBLocation>
    @Published var locationModel: LocationModel<FBImageSupportedStorage<FBLocation>>
    @Published var bucketStorage: FBUserRelatedStorage<FBBucketItem>
    @Published var bucketModel: BucketModel<FBUserRelatedStorage<FBBucketItem>>

    init(session: SessionStore) {
        let locationStorage = FBImageSupportedStorage<FBLocation>()
        self.locationStorage = locationStorage
        let locationModel = LocationModel<FBImageSupportedStorage<FBLocation>>(storage: locationStorage)
        self.locationModel = locationModel
        let bucketStorage = FBUserRelatedStorage<FBBucketItem>()
        self.bucketStorage = bucketStorage
        let bucketModel = BucketModel<FBUserRelatedStorage<FBBucketItem>>(storage: bucketStorage, userId: session.session?.id)
        self.bucketModel = bucketModel
    }
}
