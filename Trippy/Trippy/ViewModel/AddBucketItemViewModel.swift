//
//  AddBucketItemViewModel.swift
//  Trippy
//
//  Created by Lim Chun Yong on 20/3/21.
//

import Foundation

class AddBucketItemViewModel {
    private var bucketModel: BucketModel<FBStorage<FBBucketItem>>
    private var  location: Location
    private var user: User?

    init(location: Location, user: User?) {
        let storage = FBStorage<FBBucketItem>()
        self.bucketModel = BucketModel<FBStorage<FBBucketItem>>(storage: storage, userId: user?.id)
        self.location = location
        self.user = user
    }

    func saveForm(userDescription: String) throws {
        let bucketItem = try buildBucketItem(userDescription: userDescription)
        try bucketModel.addBucketItem(bucketItem: bucketItem)
    }

    private func buildBucketItem(userDescription: String) throws -> BucketItem {
        guard let locationId = location.id else {
            throw BucketListError.invalidLocation
        }
        guard let userUnwrapped = user else {
            throw BucketListError.invalidUser
        }
        let imageId = location.imageId
        let bucketItem = BucketItem(locationName: location.name,
                                    locationCategory: location.category,
                                    locationImageId: imageId,
                                    userId: userUnwrapped.id ?? "",
                                    locationId: locationId,
                                    dateVisited: nil,
                                    dateAdded: Date(),
                                    userDescription: userDescription
                                    )
        return bucketItem
    }
}
