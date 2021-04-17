//
//  SubmitRatingViewModel.swift
//  Trippy
//
//  Created by QL on 14/4/21.
//

import Foundation
import SwiftUI

class SubmitRatingViewModel {
    let locationId: String
    let userId: String
    let ratingModel: RatingModel<FBStorage<FBRating>>

    init(locationId: String, userId: String, ratingModel: RatingModel<FBStorage<FBRating>>) {
        self.locationId = locationId
        self.userId = userId
        self.ratingModel = ratingModel
    }

    func submitRating(score: Int) {
        let rating = Rating(id: nil, locationId: locationId, userId: userId, score: score, date: Date())
        do {
            try ratingModel.add(rating: rating)
        } catch {
            print("ERROR: Unable to save")
        }
    }
}
