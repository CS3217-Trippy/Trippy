import Foundation
import UIKit
@testable import Trippy
class MockImageSupportedStorage<Storable>: ImageSupportedStorage where Storable: FBImageSupportedStorable {
    typealias StoredType = Storable.ModelType

    var storedItems: Published<[Storable.ModelType]>.Publisher {
        $_storedItems
    }

    @Published private var _storedItems: [Storable.ModelType] = []

    func add(_ item: Storable.ModelType, with image: UIImage?, id: String?) throws {
        _storedItems.append(item)
    }

    func update(_ item: Storable.ModelType, with image: UIImage?) throws {
        _storedItems.removeAll { $0.id == item.id }
        _storedItems.append(item)
    }

    func remove(_ item: Storable.ModelType) {
        _storedItems.removeAll { $0.id == item.id }
    }

    func removeStoredItems() {
        _storedItems = []
    }

    func fetch() {
    }

    func fetchWithId(id: String) {
    }
 }
