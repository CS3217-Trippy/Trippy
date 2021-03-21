//
//  FBLocation.swift
//  Trippy
//
//  Created by QL on 11/3/21.
//

import FirebaseFirestoreSwift
import CoreGraphics

struct FBLocation: Identifiable, Codable {
    @DocumentID var id: String?
    var latitude: Double
    var longitude: Double
    var name: String
    var description: String
    var imageURL: String?
}
