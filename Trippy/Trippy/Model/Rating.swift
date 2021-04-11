//
//  Rating.swift
//  Trippy
//
//  Created by QL on 10/4/21.
//

import Foundation

class Rating: UserRelatedModel {
    var id: String?
    let locationId: String
    let userId: String
    let score: Int
    let date: Date
    
    init(id: String?, locationId: String, userId: String, score: Int, date: Date) {
        self.id = id
        self.locationId = locationId
        self.userId = userId
        self.score = score
        self.date = date
    }
}
