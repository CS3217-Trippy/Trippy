//
//  Visit.swift
//  Trippy
//
//  Created by QL on 17/4/21.
//

import Foundation

class Visit: Model {
    var id: String?
    var userId: String
    var bucketItemId: String
    var arrivalTime: Date

    init(id: String?, bucketItemId: String, userId: String, arrivalTime: Date) {
        self.id = id
        self.bucketItemId = bucketItemId
        self.userId = userId
        self.arrivalTime = arrivalTime
    }

}
