import Combine
import Foundation
import UIKit

final class BucketItemViewModel: ObservableObject, Identifiable {
    @Published var bucketItem: BucketItem
    @Published var upcomingMeetup: Meetup?
    @Published var location: Location?
    @Published var locationId: String?
    @Published var locationDetailViewModel: LocationDetailViewModel?
    private var bucketModel: BucketModel<FBStorage<FBBucketItem>>
    private let imageModel: ImageModel
    private let meetupModel: MeetupModel<FBStorage<FBMeetup>>
    private let locationModel: LocationModel<FBStorage<FBLocation>>
    private var user: User
    private(set) var id = ""
    @Published var image: UIImage?
    private var cancellables: Set<AnyCancellable> = []
    init(
        bucketItem: BucketItem,
        bucketModel: BucketModel<FBStorage<FBBucketItem>>,
        imageModel: ImageModel,
        meetupModel: MeetupModel<FBStorage<FBMeetup>>,
        locationModel: LocationModel<FBStorage<FBLocation>>,
        locationDetailViewModel: LocationDetailViewModel?,
        user: User
    ) {
        self.bucketItem = bucketItem
        self.bucketModel = bucketModel
        self.imageModel = imageModel
        self.meetupModel = meetupModel
        self.locationModel = locationModel
        self.locationDetailViewModel = locationDetailViewModel
        self.user = user
        $bucketItem.compactMap { $0.id }.assign(to: \.id, on: self)
            .store(in: &cancellables)
        locationModel.fetchLocationWithId(id: bucketItem.locationId, handler: fetchLocation)
        fetchUpcomingMeetup()
    }

    private func fetchLocation(location: Location) {
        if let id = location.imageId {
            imageModel.fetch(ids: [id]) { images in
                if !images.isEmpty {
                    self.image = images[0]
                }
            }
        }
        self.location = location
        self.locationId = location.id
    }

    private func fetchUpcomingMeetup() {
        meetupModel.fetchAllMeetupsWithHandler { [self] meetups in
            let meetupsRelatedToBucketItem = meetups.filter({
                let isIdEqual = $0.locationId == bucketItem.locationId
                let isPublic = $0.meetupPrivacy == .publicMeetup
                let isUserJoined = $0.hostUserId == user.id || $0.userIds.contains(user.id ?? "")
                return isIdEqual && (isPublic || isUserJoined)
            })
            .sorted(by: { $0.meetupDate < $1.meetupDate })
            if !meetupsRelatedToBucketItem.isEmpty {
                upcomingMeetup = meetupsRelatedToBucketItem[0]
            }
        }
    }

    var locationName: String? {
        location?.name
    }

    var userDescription: String {
        bucketItem.userDescription
    }
    var dateAdded: Date {
        bucketItem.dateAdded
    }
    func remove() {
        bucketModel.removeBucketItem(bucketItem: bucketItem)
    }
}
