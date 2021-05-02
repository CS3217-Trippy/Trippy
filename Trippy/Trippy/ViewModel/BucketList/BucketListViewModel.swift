import Combine

final class BucketListViewModel: ObservableObject {
    private var bucketModel: BucketModel<FBStorage<FBBucketItem>>
    @Published var bucketItemViewModels: [BucketItemViewModel] = []
    @Published var visitedBucketItemViewModels: [BucketItemViewModel] = []
    private let imageModel: ImageModel
    private let meetupModel: MeetupModel<FBStorage<FBMeetup>>
    private var cancellables: Set<AnyCancellable> = []
    private let locationModel: LocationModel<FBStorage<FBLocation>>
    private var locationListViewModel: LocationListViewModel
    var isEmpty: Bool {
        bucketItemViewModels.isEmpty
    }

    init(
        bucketModel: BucketModel<FBStorage<FBBucketItem>>,
        imageModel: ImageModel,
        meetupModel: MeetupModel<FBStorage<FBMeetup>>,
        locationList: LocationListViewModel,
        user: User
    ) {
        self.bucketModel = bucketModel
        self.imageModel = imageModel
        self.meetupModel = meetupModel
        self.locationListViewModel = locationList
        self.locationModel = locationList.locationModel
        bucketModel.$bucketItems.map { bucketItem in
            bucketItem.filter({ $0.dateVisited != nil }).map { bucketItem in
                let detailViewModel = self.getLocationDetailViewModel(locationId: bucketItem.locationId)
                return BucketItemViewModel(
                    bucketItem: bucketItem,
                    bucketModel: bucketModel,
                    imageModel: imageModel,
                    meetupModel: meetupModel,
                    locationModel: locationList.locationModel,
                    locationDetailViewModel: detailViewModel,
                    user: user)
            }
        }
        .assign(to: \.visitedBucketItemViewModels, on: self)
        .store(in: &cancellables)

        bucketModel.$bucketItems.map { bucketItem in
            bucketItem.filter({ $0.dateVisited == nil }).map { bucketItem in
                let detailViewModel = self.getLocationDetailViewModel(locationId: bucketItem.locationId)
                return BucketItemViewModel(
                    bucketItem: bucketItem,
                    bucketModel: bucketModel,
                    imageModel: imageModel,
                    meetupModel: meetupModel,
                    locationModel: self.locationModel,
                    locationDetailViewModel: detailViewModel,
                    user: user)
            }
        }
        .assign(to: \.bucketItemViewModels, on: self)
        .store(in: &cancellables)
        fetch()
    }

    func getLocationDetailViewModel(locationId: String) -> LocationDetailViewModel? {
        locationListViewModel.getDetailViewModel(locationId: locationId)
    }

    /// Fetches list of bucket items owned by the user
    func fetch() {
        bucketModel.fetchBucketItems()
    }

}
