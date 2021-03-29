//
//  Storage.swift
//  Trippy
//
//  Created by QL on 24/3/21.
//

import Combine
import UIKit

protocol ImageSupportedStorage: ObservableObject {
    associatedtype StoredType

    var storedItems: Published<[StoredType]>.Publisher { get }

    func fetch()

    func fetchWithId(id: String)

    func add(_ item: StoredType, with image: UIImage?, id: String?) throws

    func update(_ item: StoredType, with image: UIImage?) throws

    func remove(_ item: StoredType)
}
