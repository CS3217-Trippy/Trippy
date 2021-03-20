import Combine
import Foundation

final class BucketItemViewModel: ObservableObject, Identifiable {
    @Published private var bucketItem: BucketItem
    private(set) var id = ""
    private var cancellables: Set<AnyCancellable> = []
    var locationImage: String {
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
    init(bucketItem: BucketItem) {
        self.bucketItem = bucketItem
        $bucketItem.compactMap { $0.id }.assign(to: \.id, on: self)
            .store(in: &cancellables)
    }
}
