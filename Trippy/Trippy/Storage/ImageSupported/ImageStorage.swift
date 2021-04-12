import UIKit
protocol ImageStorage {
    func add(with images: [TrippyImage], callback: (([String]) -> Void)?)
    func fetch(ids: [String], callback: @escaping ([UIImage]) -> Void)
}
