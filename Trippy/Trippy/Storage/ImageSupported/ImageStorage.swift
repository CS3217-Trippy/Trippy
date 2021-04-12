import UIKit
protocol ImageStorage {
    func add(with images: [TrippyImage])
    func fetch(ids: [String], callback: @escaping ([UIImage]) -> Void)
}
