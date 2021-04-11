import UIKit

class ImageModel {
    private var storage: ImageStorage

    init(storage: ImageStorage) {
        self.storage = storage
    }

    func add(with images: [TrippyImage]) {
        storage.add(with: images)
    }

    func fetch(ids: [String], callback: @escaping ([UIImage]) -> Void) {
        storage.fetch(ids: ids, callback: callback)
    }
}
