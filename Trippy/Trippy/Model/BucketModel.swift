import Combine

class BucketModel : ObservableObject {
    @Published private(set) var bucketItems: [BucketItem] = []
    private let storage: BucketListStorage
    private var cancellables: Set<AnyCancellable> = []
    init(storage: BucketListStorage) {
        self.storage = storage
        getBucketItems()
    }
    func getBucketItems() {
        storage.bucketList.assign(to: \.bucketItems, on: self)
            .store(in: &cancellables)
    }
    
    func addBucketItem(bucketItem: BucketItem) throws {
        try storage.addBucketItem(bucketItem: bucketItem)
        bucketItems.append(bucketItem)
    }
    func removeBucketItem(bucketItem: BucketItem) {
        storage.removeBucketItem(bucketItem: bucketItem)
        bucketItems.removeAll{$0.id == bucketItem.id}
    }
    func updateBucketItem(bucketItem: BucketItem) throws {
        try storage.updateBucketItem(bucketItem: bucketItem)
        bucketItems = bucketItems.map{item in
            if item.id == bucketItem.id {
                return bucketItem
            }
            return item
        }
    }
}

