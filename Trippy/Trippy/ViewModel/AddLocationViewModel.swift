//
//  AddLocationViewModel.swift
//  Trippy
//
//  Created by QL on 17/3/21.
//

import CoreLocation
import UIKit

class AddLocationViewModel {
    let locationModel: LocationModel

    init(locationModel: LocationModel) {
        self.locationModel = locationModel
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

    func saveForm(name: String, description: String, coordinates: CLLocationCoordinate2D, image: UIImage?) throws {
        let formattedName = name.trimmingCharacters(in: .whitespacesAndNewlines).capitalized
        let formattedDescription = description.trimmingCharacters(in: .whitespacesAndNewlines)
        try locationModel.addLocation(
            location: .init(id: nil, coordinates: coordinates, name: formattedName, description: formattedDescription),
            image: image
        )
    }
}
