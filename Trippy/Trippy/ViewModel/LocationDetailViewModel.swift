//
//  LocationDetailViewModel.swift
//  Trippy
//
//  Created by QL on 15/3/21.
//

import Combine
import Contacts
import UIKit

class LocationDetailViewModel: ObservableObject {
    @Published var location: Location
    private var cancellables: Set<AnyCancellable> = []
    @Published var image: UIImage?

    init(location: Location) {
        self.location = location
        fetchImage()
    }

    private func fetchImage() {
        let id = location.imageId
        let model = ImageModel(storage: FBImageStorage())
        guard let imageId = id else {
            return
        }
        model.fetch(ids: [imageId]) { images in
            if !images.isEmpty {
                self.image = images[0]
            }
        }
    }

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
    var category: String {
        location.category.rawValue.capitalized
    }

}
