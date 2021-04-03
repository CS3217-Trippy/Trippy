//
//  AddLocationViewModel.swift
//  Trippy
//
//  Created by QL on 17/3/21.
//

import CoreLocation
import UIKit

class AddLocationViewModel {
    let locationModel: LocationModel<FBImageSupportedStorage<FBLocation>>

    init(locationModel: LocationModel<FBImageSupportedStorage<FBLocation>>) {
        self.locationModel = locationModel
    }

    var categories: [String] {
        LocationCategory.allCases.map { $0.rawValue }
    }

    func isValidName(name: String) -> Bool {
        let formattedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        return !formattedName.isEmpty && formattedName.count <= 50
    }

    func isValidDescription(description: String) -> Bool {
        let formattedDescription = description.trimmingCharacters(in: .whitespacesAndNewlines)
        return !formattedDescription.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            && formattedDescription.count <= 500
    }

    func isValidCategory(category: String) -> Bool {
        let category = LocationCategory(rawValue: category)
        return category != nil
    }

    func saveForm(name: String,
                  description: String,
                  category: String,
                  coordinates: CLLocationCoordinate2D,
                  image: UIImage?) throws {
        let formattedName = name.trimmingCharacters(in: .whitespacesAndNewlines).capitalized
        let formattedDescription = description.trimmingCharacters(in: .whitespacesAndNewlines)
        guard let categoryEnum = LocationCategory(rawValue: category) else {
            return
        }
        try locationModel.addLocation(
            location: .init(id: nil,
                            coordinates: coordinates,
                            name: formattedName,
                            description: formattedDescription,
                            category: categoryEnum),
            image: image
        )
    }
}
