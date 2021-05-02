//
//  FBVisit.swift
//  Trippy
//
//  Created by QL on 17/4/21.
//

import Foundation
import FirebaseFirestoreSwift
import CoreLocation

struct FBVisit: FBStorable {
    typealias ModelType = Visit
    static var path = "visits"

    @DocumentID var id: String?
    var userId: String
    var bucketItemId: String
    var arrivalTime: Date

    init(item: ModelType) {
        id = item.id
        userId = item.userId
        bucketItemId = item.bucketItemId
        arrivalTime = item.arrivalTime
    }

    func convertToModelType() -> Visit {
        Visit(id: id, bucketItemId: bucketItemId, userId: userId, arrivalTime: arrivalTime)
    }

    private enum CodingKeys: String, CodingKey {
        case id, userId, bucketItemId, arrivalTime
    }
}
