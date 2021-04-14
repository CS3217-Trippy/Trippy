import Combine

class BucketModel<Storage: StorageProtocol>: ObservableObject where Storage.StoredType == BucketItem {
    @Published private(set) var bucketItems: [BucketItem] = []
    private let storage: Storage
    private var cancellables: Set<AnyCancellable> = []
    let userId: String?

    init(storage: Storage, userId: String?) {
        self.storage = storage
        self.userId = userId
        storage.storedItems.assign(to: \.bucketItems, on: self)
            .store(in: &cancellables)
        fetchBucketItems()
    }

    func fetchBucketItems() {
        guard let userId = userId else {
            return
        }
        let field = "userId"
        storage.fetchWithField(field: field, value: userId, handler: nil)
    }

    func addBucketItem(bucketItem: BucketItem) throws {
        guard !bucketItems.contains(where: { $0.id == bucketItem.id }) else {
            return
        }
        try storage.add(item: bucketItem)
    }

    func removeBucketItem(bucketItem: BucketItem) {
        guard bucketItems.contains(where: { $0.id == bucketItem.id }) else {
            return
        }
        storage.remove(item: bucketItem)
    }

    func updateBucketItem(bucketItem: BucketItem) throws {
        guard bucketItems.contains(where: { $0.id == bucketItem.id }) else {
            return
        }
        try storage.update(item: bucketItem, handler: nil)
    }
}
