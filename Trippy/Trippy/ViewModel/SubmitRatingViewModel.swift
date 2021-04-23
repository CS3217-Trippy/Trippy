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

    var hasRated: Bool {
        ratingModel.ratings.contains { $0.userId == userId && $0.locationId == locationId }
    }

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

    func updateRating(score: Int) {
        let oldRating = ratingModel.ratings.first { $0.locationId == locationId && $0.userId == userId }
        let rating = Rating(id: oldRating?.id, locationId: locationId,
                            userId: userId, score: score, date: Date())
        do {
            try ratingModel.updateRating(updatedRating: rating)
        } catch {
            print("ERROR: Unable to save")
        }
    }
}
