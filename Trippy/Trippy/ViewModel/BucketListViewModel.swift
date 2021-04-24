import Combine

final class BucketListViewModel: ObservableObject {
    private var bucketModel: BucketModel<FBStorage<FBBucketItem>>
    @Published var bucketItemViewModels: [BucketItemViewModel] = []
    @Published var visitedBucketItemViewModels: [BucketItemViewModel] = []
    private let imageModel: ImageModel
    private let meetupModel: MeetupModel<FBStorage<FBMeetup>>
    private var cancellables: Set<AnyCancellable> = []
    var isEmpty: Bool {
        bucketItemViewModels.isEmpty
    }

    init(
        bucketModel: BucketModel<FBStorage<FBBucketItem>>,
        imageModel: ImageModel,
        meetupModel: MeetupModel<FBStorage<FBMeetup>>
    ) {
        self.bucketModel = bucketModel
        self.imageModel = imageModel
        self.meetupModel = meetupModel

        bucketModel.$bucketItems.map { bucketItem in
            bucketItem.filter({ $0.dateVisited != nil }).map { bucketItem in
                BucketItemViewModel(
                    bucketItem: bucketItem, bucketModel: bucketModel, imageModel: imageModel, meetupModel: meetupModel)
            }
        }
        .assign(to: \.visitedBucketItemViewModels, on: self)
        .store(in: &cancellables)

        bucketModel.$bucketItems.map { bucketItem in
            bucketItem.filter({ $0.dateVisited == nil }).map { bucketItem in
                BucketItemViewModel(
                    bucketItem: bucketItem, bucketModel: bucketModel, imageModel: imageModel, meetupModel: meetupModel)
            }
        }
        .assign(to: \.bucketItemViewModels, on: self)
        .store(in: &cancellables)
        fetch()
    }

    /// Fetches list of bucket items owned by the user
    func fetch() {
        bucketModel.fetchBucketItems()
    }

}
