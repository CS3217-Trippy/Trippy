import Combine

final class BucketListViewModel: ObservableObject {
    private var bucketModel: BucketModel<FBStorage<FBBucketItem>>
    @Published var bucketItemViewModels: [BucketItemViewModel] = []
    private let imageModel: ImageModel
    private var cancellables: Set<AnyCancellable> = []
    var isEmpty: Bool {
        bucketItemViewModels.isEmpty
    }

    init(bucketModel: BucketModel<FBStorage<FBBucketItem>>, imageModel: ImageModel) {
        self.bucketModel = bucketModel
        self.imageModel = imageModel
        bucketModel.$bucketItems.map { bucketItem in
            bucketItem.filter({ $0.dateVisited == nil }).map { bucketItem in
                BucketItemViewModel(bucketItem: bucketItem, bucketModel: bucketModel, imageModel: imageModel)
            }
        }
        .assign(to: \.bucketItemViewModels, on: self)
        .store(in: &cancellables)
    }

    /// Fetches list of bucket items owned by the user
    func fetch() {
        bucketModel.fetchBucketItems()
    }

}
