import Combine
import Foundation
import UIKit

/// View model of an itinerary item.
final class ItineraryItemViewModel: ObservableObject, Identifiable {
    @Published var itineraryItem: ItineraryItem
    @Published var upcomingMeetup: Meetup?
    @Published var image: UIImage?
    @Published var location: Location?
    private var cancellables: Set<AnyCancellable> = []
    private var itineraryModel: ItineraryModel<FBStorage<FBItineraryItem>>
    private var user: User
    private let locationModel: LocationModel<FBStorage<FBLocation>>
    private let imageModel: ImageModel
    private let meetupModel: MeetupModel<FBStorage<FBMeetup>>
    private(set) var id = ""
    init(
        itineraryItem: ItineraryItem,
        itineraryModel: ItineraryModel<FBStorage<FBItineraryItem>>,
        imageModel: ImageModel,
        meetupModel: MeetupModel<FBStorage<FBMeetup>>,
        locationModel: LocationModel<FBStorage<FBLocation>>,
        user: User
    ) {
        self.itineraryItem = itineraryItem
        self.itineraryModel = itineraryModel
        self.imageModel = imageModel
        self.meetupModel = meetupModel
        self.locationModel = locationModel
        self.user = user
        $itineraryItem.compactMap { $0.id }.assign(to: \.id, on: self)
            .store(in: &cancellables)
        locationModel.fetchLocationWithId(id: itineraryItem.locationId, handler: fetchItinerary)
    }

    private func fetchItinerary(location: Location) {
        if let id = location.imageId {
            imageModel.fetch(ids: [id]) { images in
                if !images.isEmpty {
                    self.image = images[0]
                }
            }
        }
        self.location = location
        fetchUpcomingMeetup()
    }

    private func fetchUpcomingMeetup() {
        meetupModel.fetchAllMeetupsWithHandler { [self] meetups in
            let meetupsRelatedToBucketItem = meetups.filter({
                let isIdEqual = $0.locationId == itineraryItem.locationId
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

    /// Remove an itinerary item.
    func remove() {
        itineraryModel.removeItineraryItem(itineraryItem: itineraryItem)
    }
}
