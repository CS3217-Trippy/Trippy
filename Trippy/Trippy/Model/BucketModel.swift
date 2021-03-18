import Combine

class BucketModel : ObservableObject {
    @Published private(set) var bucketItems: [BucketItem] = []
    private let storage: BucketListStorage
    private var cancellables: Set<AnyCancellable> = []
    init(storage: BucketListStorage) {
        self.storage = storage
        storage.bucketList.assign(to: \.bucketItems, on: self)
            .store(in: &cancellables)
        fetchBucketItems()
    }

    func fetchBucketItems() {
        storage.fetchBucketItems()
    }

    func addBucketItem(bucketItem: BucketItem) throws {
        try storage.addBucketItem(bucketItem: bucketItem)
    }

    func removeBucketItem(bucketItem: BucketItem) {
        storage.removeBucketItem(bucketItem: bucketItem)
    }

    func updateBucketItem(bucketItem: BucketItem) throws {
        try storage.updateBucketItem(bucketItem: bucketItem)
    }
}

