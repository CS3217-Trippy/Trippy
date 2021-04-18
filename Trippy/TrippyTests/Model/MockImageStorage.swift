//
//  MockImageStorage.swift
//  TrippyTests
//
//  Created by QL on 18/4/21.
//

@testable import Trippy
import UIKit
import Combine

class MockImageStorage: ImageStorage {
    var storedItems: [TrippyImage] = []

    func add(with images: [TrippyImage], callback: (([String]) -> Void)?) {
        storedItems += images
    }

    func fetch(ids: [String], callback: @escaping ([UIImage]) -> Void) {
        let fetchedItems = storedItems.filter { item in
            ids.contains(where: { $0 == item.id })
        }

        callback(fetchedItems.map({ $0.image }))
    }
}
