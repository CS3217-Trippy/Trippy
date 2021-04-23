import Combine
import Foundation
import UIKit

/// View model of an itinerary item.
final class ItineraryItemViewModel: ObservableObject, Identifiable {
    @Published var itineraryItem: ItineraryItem
    @Published var upcomingMeetup: Meetup?
    private var itineraryModel: ItineraryModel<FBStorage<FBItineraryItem>>
    private let imageModel: ImageModel
    private let meetupModel: MeetupModel<FBStorage<FBMeetup>>
    private(set) var id = ""
    init(
        itineraryItem: ItineraryItem,
        itineraryModel: ItineraryModel<FBStorage<FBItineraryItem>>,
        imageModel: ImageModel,
        meetupModel: MeetupModel<FBStorage<FBMeetup>>
    ) {
        self.itineraryItem = itineraryItem
        self.itineraryModel = itineraryModel
        self.imageModel = imageModel
        self.meetupModel = meetupModel
        $itineraryItem.compactMap { $0.id }.assign(to: \.id, on: self)
            .store(in: &cancellables)
        fetchImage()
        fetchUpcomingMeetup()
    }

    private func fetchUpcomingMeetup() {
        meetupModel.fetchAllMeetupsWithHandler { [self] meetups in
            let meetupsRelatedToBucketItem = meetups.filter({ $0.locationId == itineraryItem.locationId })
                .sorted(by: { $0.meetupDate < $1.meetupDate })
            if !meetupsRelatedToBucketItem.isEmpty {
                upcomingMeetup = meetupsRelatedToBucketItem[0]
            }
        }
    }

    private func fetchImage() {
        let id = itineraryItem.locationImageId
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
        itineraryItem.locationName
    }

    /// Remove an itinerary item.
    func remove() {
        itineraryModel.removeItineraryItem(itineraryItem: itineraryItem)
    }
}
