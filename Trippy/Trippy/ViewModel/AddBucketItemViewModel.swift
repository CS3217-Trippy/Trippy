//
//  AddBucketItemViewModel.swift
//  Trippy
//
//  Created by Lim Chun Yong on 20/3/21.
//

import Foundation

class AddBucketItemViewModel {
    let bucketModel: BucketModel
    let location: Location
    let user: User?

    init(bucketModel: BucketModel, location: Location, user: User?) {
        self.bucketModel = bucketModel
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
        let bucketItem = BucketItem(locationName: location.name,
                                    locationImage: location.imageURL,
                                    userId: userUnwrapped.id ?? "",
                                    locationId: locationId,
                                    dateVisited: nil,
                                    dateAdded: Date(),
                                    userDescription: userDescription
                                    )
        return bucketItem
    }
}
