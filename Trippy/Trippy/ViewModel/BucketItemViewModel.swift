import Combine

final class BucketItemViewModel : ObservableObject, Identifiable {
    @Published var bucketItem: BucketItem
    private(set) var id = ""
    private var cancellables: Set<AnyCancellable> = []
    init(bucketItem: BucketItem) {
        self.bucketItem = bucketItem
        $bucketItem.compactMap{$0.id}.assign(to: \.id, on: self)
            .store(in: &cancellables)
    }
}
