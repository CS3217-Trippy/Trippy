//
//  LocationDetailViewModel.swift
//  Trippy
//
//  Created by QL on 15/3/21.
//

import Combine
import Contacts

class LocationDetailViewModel: ObservableObject {
    @Published var location: Location
    private var cancellables: Set<AnyCancellable> = []
    
    var title: String {
        location.name
    }
    
    var address: String {
        let postalAddressFormatter = CNPostalAddressFormatter()
        postalAddressFormatter.style = .mailingAddress
        var addressString: String?
        if let postalAddress = location.placemark?.postalAddress {
            addressString = postalAddressFormatter.string(from: postalAddress)
        }
        return addressString ?? ""
    }
    
    var description: String {
        location.description
    }
    
    init(location: Location) {
        self.location = location
    }
}
