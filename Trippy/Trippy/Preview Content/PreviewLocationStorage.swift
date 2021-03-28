//
//  PreviewLocationStorage.swift
//  Trippy
//
//  Created by QL on 13/3/21.
//

import CoreLocation
import Combine
import UIKit

class PreviewLocationStorage: ImageSupportedStorage {
    var storedItems: Published<[Location]>.Publisher {
        $_storedItems
    }

    @Published private var _storedItems: [Location] = []

    func fetch() {
        _storedItems = PreviewLocations.locations
    }

    func add(_ item: Location, with image: UIImage?, id: String?) throws {
        // Does Nothing
        return
    }

    func update(_ item: Location, with image: UIImage?) throws {
        // Does Nothing
        return
    }

    func remove(_ item: Location) {
        // Does Nothing
        return
    }
}
