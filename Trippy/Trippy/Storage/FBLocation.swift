//
//  FBMeetup.swift
//  Trippy
//
//  Created by QL on 24/3/21.
//

import FirebaseFirestoreSwift
import CoreGraphics
import UIKit
import CoreLocation

struct FBLocation: FBStorable {
    typealias ModelType = Location
    static var path = "locations"

    @DocumentID var id: String?
    var latitude: Double
    var longitude: Double
    var name: String
    var description: String
    var category: LocationCategory
    var imageIds: [String] = []

    init(item: ModelType) {
        id = item.id
        latitude = item.coordinates.latitude
        longitude = item.coordinates.longitude
        name = item.name
        description = item.description
        category = item.category
        if let imageId = item.imageId {
            imageIds.append(imageId)
        }
    }

    func convertToModelType() -> Location {
        var imageId: String?
        if !imageIds.isEmpty {
            imageId = imageIds[0]
        }
        let location = Location(
            id: id,
            coordinates: CLLocationCoordinate2D(latitude: latitude, longitude: longitude),
            name: name,
            description: description,
            category: category,
            imageId: imageId
        )
        return location
    }

    private enum CodingKeys: String, CodingKey {
        case id, latitude, longitude, name, description, category, imageIds
    }
}
