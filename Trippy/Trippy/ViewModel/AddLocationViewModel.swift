//
//  AddLocationViewModel.swift
//  Trippy
//
//  Created by QL on 17/3/21.
//


import CoreLocation

class AddLocationViewModel {
    let locationModel: LocationModel
    
    init(locationModel: LocationModel) {
        self.locationModel=locationModel
    }
    
    func isValidName(name: String) -> Bool {
        return !name.isEmpty && name.count < 50
    }
    
    func isValidDescription(description: String) -> Bool {
        return !description.isEmpty && description.count < 500
    }
    
    func saveForm(name: String, description: String, coordinates: CLLocationCoordinate2D) throws {
        try locationModel.addLocation(location: .init(id: nil, coordinates: coordinates, name: name, description: description))
    }
}
