import Combine

final class BucketListViewModel: ObservableObject {
    private var bucketModel: BucketModel<FBStorage<FBBucketItem>>
    @Published var bucketItemViewModels: [BucketItemViewModel] = []
    @Published var visitedBucketItemViewModels: [BucketItemViewModel] = []
    private let imageModel: ImageModel
    private let meetupModel: MeetupModel<FBStorage<FBMeetup>>
    private var cancellables: Set<AnyCancellable> = []
    private let locationModel: LocationModel<FBStorage<FBLocation>>
    var locationListViewModel: LocationListViewModel
    var isEmpty: Bool {
        bucketItemViewModels.isEmpty
    }

    init(
        bucketModel: BucketModel<FBStorage<FBBucketItem>>,
        imageModel: ImageModel,
        meetupModel: MeetupModel<FBStorage<FBMeetup>>,
        locationList: LocationListViewModel
    ) {
        self.bucketModel = bucketModel
        self.imageModel = imageModel
        self.meetupModel = meetupModel
        self.locationListViewModel = locationList
        self.locationModel = locationList.locationModel
        bucketModel.$bucketItems.map { bucketItem in
            bucketItem.filter({ $0.dateVisited != nil }).map { bucketItem in
                BucketItemViewModel(
                    bucketItem: bucketItem,
                    bucketModel: bucketModel,
                    imageModel: imageModel,
                    meetupModel: meetupModel,
                    locationModel: locationList.locationModel)
            }
        }
        .assign(to: \.visitedBucketItemViewModels, on: self)
        .store(in: &cancellables)

        bucketModel.$bucketItems.map { bucketItem in
            bucketItem.filter({ $0.dateVisited == nil }).map { bucketItem in
                BucketItemViewModel(
                    bucketItem: bucketItem,
                    bucketModel: bucketModel,
                    imageModel: imageModel,
                    meetupModel: meetupModel,
                    locationModel: self.locationModel)
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
