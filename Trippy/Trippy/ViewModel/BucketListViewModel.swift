import Combine

final class BucketListViewModel : ObservableObject {
    @Published var storage = BucketItemStorage()
    @Published var bucketViewModels: [BucketItemViewModel] = []
    private var cancellables: Set<AnyCancellable> = []
    
    init() {
        mapDbToBucketItem()
    }
    
    func mapDbToBucketItem() {
        storage.$bucketItems.map{bucket in
            bucket.map(BucketItemViewModel.init)
        }.assign(to: \.bucketViewModels, on: self)
        .store(in: &cancellables)
    }
    
    func add(bucketItem: BucketItem) {
        storage.add(item: bucketItem)
    }
    
}
