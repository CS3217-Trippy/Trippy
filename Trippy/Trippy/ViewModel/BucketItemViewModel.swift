import Combine
import Foundation
import UIKit

final class BucketItemViewModel: ObservableObject, Identifiable {
    @Published var bucketItem: BucketItem
    @Published var upcomingMeetup: Meetup?
    private var bucketModel: BucketModel<FBStorage<FBBucketItem>>
    private let imageModel: ImageModel
    private let meetupModel: MeetupModel<FBStorage<FBMeetup>>
    private(set) var id = ""
    init(
        bucketItem: BucketItem,
        bucketModel: BucketModel<FBStorage<FBBucketItem>>,
        imageModel: ImageModel,
        meetupModel: MeetupModel<FBStorage<FBMeetup>>
    ) {
        self.bucketItem = bucketItem
        self.bucketModel = bucketModel
        self.imageModel = imageModel
        self.meetupModel = meetupModel
        $bucketItem.compactMap { $0.id }.assign(to: \.id, on: self)
            .store(in: &cancellables)
        fetchImage()
        fetchUpcomingMeetup()
    }

    private func fetchUpcomingMeetup() {
        meetupModel.fetchAllMeetupsWithHandler { [self] meetups in
            let meetupsRelatedToBucketItem = meetups.filter({ $0.locationId == bucketItem.locationId })
                .sorted(by: { $0.meetupDate < $1.meetupDate })
            if !meetupsRelatedToBucketItem.isEmpty {
                upcomingMeetup = meetupsRelatedToBucketItem[0]
            }
        }
    }

    private func fetchImage() {
        let id = bucketItem.locationImageId
        guard let imageId = id else {
            return
        }
        imageModel.fetch(ids: [imageId]) { images in
            if !images.isEmpty {
                self.image = images[0]
            }
        }
    }

    @Published var image: UIImage?
    private var cancellables: Set<AnyCancellable> = []
    var locationName: String {
        bucketItem.locationName
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
