//
//  HomepageViewModel.swift
//  Trippy
//
//  Created by Audrey Felicio Anwar on 18/3/21.
//

import Combine

final class HomepageViewModel: ObservableObject {
    @Published var locationStorage: LocationStorage
    @Published var locationModel: LocationModel
    @Published var bucketStorage: BucketListStorage
    @Published var bucketModel: BucketModel

    init(session: SessionStore) {
        let locationStorage = FBLocationStorage()
        self.locationStorage = locationStorage
        let locationModel = LocationModel(storage: locationStorage)
        self.locationModel = locationModel
        let bucketStorage = FBBucketListStorage(user: session.session)
        self.bucketStorage = bucketStorage
        let bucketModel = BucketModel(storage: bucketStorage)
        self.bucketModel = bucketModel
    }
}
