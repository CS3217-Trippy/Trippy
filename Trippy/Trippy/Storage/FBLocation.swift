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

struct FBLocation: FBImageSupportedStorable {
    typealias ModelType = Location
    static var path = "locations"

    @DocumentID var id: String?
    var latitude: Double
    var longitude: Double
    var name: String
    var description: String
    var category: LocationCategory
    var imageURL: [String] = []

    init(item: ModelType) {
        id = item.id
        latitude = item.coordinates.latitude
        longitude = item.coordinates.longitude
        name = item.name
        description = item.description
        category = item.category
    }

    func convertToModelType() -> Location {
        let location = Location(
            id: id,
            coordinates: CLLocationCoordinate2D(latitude: latitude, longitude: longitude),
            name: name,
            description: description,
            category: category
        )

        if !imageURL.isEmpty {
            let url = imageURL[0]
            Downloader.getDataFromString(from: url) { data, _, error in
                guard let data = data, error == nil else {
                    return
                }
                DispatchQueue.main.async {
                    let image = UIImage(data: data)
                    location.image = image
                }
            }
        }
        return location
    }

    private enum CodingKeys: String, CodingKey {
        case id, latitude, longitude, name, description, category, imageURL
    }
}
