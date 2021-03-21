import Combine
import Foundation

final class BucketItemViewModel: ObservableObject, Identifiable {
    @Published private var bucketItem: BucketItem
    private var bucketModel: BucketModel
    private(set) var id = ""
    private var cancellables: Set<AnyCancellable> = []
    var locationImage: URL? {
        bucketItem.locationImage
    }
    var locationName: String {
        bucketItem.locationName
    }
    var userDescription: String {
        bucketItem.userDescription
    }
    var dateAdded: Date {
        bucketItem.dateAdded
    }
    init(bucketItem: BucketItem, bucketModel: BucketModel) {
        self.bucketItem = bucketItem
        self.bucketModel = bucketModel
        $bucketItem.compactMap { $0.id }.assign(to: \.id, on: self)
            .store(in: &cancellables)
    }
    func remove() {
        bucketModel.removeBucketItem(bucketItem: bucketItem)
    }
}
