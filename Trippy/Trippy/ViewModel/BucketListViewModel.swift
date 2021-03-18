import Combine

final class BucketListViewModel: ObservableObject {
    @Published var bucketModel: BucketModel
    @Published var bucketItemViewModels: [BucketItemViewModel] = []
    private var cancellables: Set<AnyCancellable> = []

    init(bucketModel: BucketModel) {
        self.bucketModel = bucketModel
        bucketModel.$bucketItems.map { bucketItem in
            bucketItem.map(BucketItemViewModel.init)
        }
        .assign(to: \.bucketItemViewModels, on: self)
        .store(in: &cancellables)
    }

}
