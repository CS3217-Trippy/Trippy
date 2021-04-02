import Combine

final class BucketListViewModel: ObservableObject {
    private var bucketModel: BucketModel<FBUserRelatedStorage<FBBucketItem>>
    @Published var bucketItemViewModels: [BucketItemViewModel] = []
    private var cancellables: Set<AnyCancellable> = []
    var isEmpty: Bool {
        bucketItemViewModels.isEmpty
    }

    init(bucketModel: BucketModel<FBUserRelatedStorage<FBBucketItem>>) {
        self.bucketModel = bucketModel
        bucketModel.$bucketItems.map { bucketItem in
            bucketItem.filter({ $0.dateVisited == nil }).map { bucketItem in
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
