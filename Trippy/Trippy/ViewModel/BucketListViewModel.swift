import Combine

final class BucketListViewModel : ObservableObject {
    @Published var repository = BucketItemRepository()
    @Published var bucketViewModels: [BucketItemViewModel] = []
    private var cancellables: Set<AnyCancellable> = []
    
    init() {
        mapDbToBucketItem()
    }
    
    func mapDbToBucketItem() {
        repository.$bucketItems.map{bucket in
            bucket.map(BucketItemViewModel.init)
        }.assign(to: \.bucketViewModels, on: self)
        .store(in: &cancellables)
    }
    
    func add(bucketItem: BucketItem) {
        repository.add(item: bucketItem)
    }
    
}

