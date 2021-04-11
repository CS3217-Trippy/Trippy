//
//  FBRating.swift
//  Trippy
//
//  Created by QL on 11/4/21.
//

import FirebaseFirestoreSwift
import CoreGraphics
import UIKit
import CoreLocation

struct FBRating: FBUserRelatedStorable {
    typealias ModelType = Rating
    static var path = "rating"

    @DocumentID var id: String?
    let locationId: String
    let userId: String
    let score: Int
    let date: Date
    

    init(item: ModelType) {
        id = item.id
        locationId = item.locationId
        userId = item.userId
        score = item.score
        date = item.date
    }

    func convertToModelType() -> Rating {
        return Rating(
            id: id,
            locationId: locationId,
            userId: userId,
            score: score,
            date: date
        )
    }

    private enum CodingKeys: String, CodingKey {
        case id, locationId, userId, score, date
    }
}

