import Combine

final class BucketListViewModel: ObservableObject {
    @Published var bucketModel: BucketModel
    @Published var bucketItemViewModels: [BucketItemViewModel] = []
    private var cancellables: Set<AnyCancellable> = []
    var isEmpty: Bool {
        bucketItemViewModels.isEmpty
    }

    init(bucketModel: BucketModel) {
        self.bucketModel = bucketModel
        bucketModel.$bucketItems.map { bucketItem in
            bucketItem.map { bucketItem in
                BucketItemViewModel(bucketItem: bucketItem, bucketModel: bucketModel)
            }
        }
        .assign(to: \.bucketItemViewModels, on: self)
        .store(in: &cancellables)
    }

    func fetch() {
        bucketModel.fetchBucketItems()
    }

}
