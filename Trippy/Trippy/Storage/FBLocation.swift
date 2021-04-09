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

final class FBLocation: FBImageSupportedStorable {
    typealias ModelType = Location
    static var path = "locations"

    @DocumentID var id: String?
    var latitude: Double
    var longitude: Double
    var name: String
    var description: String
    var category: LocationCategory
    var imageURL: String?

    init(item: ModelType) {
        let imageURL = item.imageURL?.absoluteString

        id = item.id
        latitude = item.coordinates.latitude
        longitude = item.coordinates.longitude
        name = item.name
        description = item.description
        category = item.category
        self.imageURL = imageURL
    }

    func adddURLToObject(images: [String]) {
        guard !images.isEmpty else {
            return
        }
        self.imageURL = images[0]
    }

    func convertToModelType() -> Location {
        var targetURL: URL?
        if let url = imageURL {
            targetURL = URL(string: url)
        }
        return Location(
            id: id,
            coordinates: CLLocationCoordinate2D(latitude: latitude, longitude: longitude),
            name: name,
            description: description,
            category: category,
            imageURL: targetURL
        )
    }

    private enum CodingKeys: String, CodingKey {
        case id, latitude, longitude, name, description, category, imageURL
    }
}
