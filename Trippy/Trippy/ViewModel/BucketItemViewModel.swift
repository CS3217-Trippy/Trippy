import Combine
import Foundation
import UIKit

final class BucketItemViewModel: ObservableObject, Identifiable {
    @Published private var bucketItem: BucketItem
    private var bucketModel: BucketModel<FBStorage<FBBucketItem>>
    private let imageModel: ImageModel
    private(set) var id = ""
    init(bucketItem: BucketItem, bucketModel: BucketModel<FBStorage<FBBucketItem>>, imageModel: ImageModel) {
        self.bucketItem = bucketItem
        self.bucketModel = bucketModel
        self.imageModel = imageModel
        $bucketItem.compactMap { $0.id }.assign(to: \.id, on: self)
            .store(in: &cancellables)
        fetchImage()
    }

    private func fetchImage() {
        let id = bucketItem.locationImageId
        guard let imageId = id else {
            return
        }
        imageModel.fetch(ids: [imageId]) { images in
            if !images.isEmpty {
                self.image = images[0]
            }
        }
    }

    @Published var image: UIImage?
    private var cancellables: Set<AnyCancellable> = []
    var locationName: String {
        bucketItem.locationName
    }
    var userDescription: String {
        bucketItem.userDescription
    }
    var dateAdded: Date {
        bucketItem.dateAdded
    }
    func remove() {
        bucketModel.removeBucketItem(bucketItem: bucketItem)
    }
}
