import Foundation

class AddItineraryItemViewModel {
    private var itineraryModel: ItineraryModel<FBStorage<FBItineraryItem>>
    private var  location: Location
    private var user: User?

    init(location: Location, user: User?) {
        let storage = FBStorage<FBItineraryItem>()
        self.itineraryModel = ItineraryModel<FBStorage<FBItineraryItem>>(storage: storage, userId: user?.id)
        self.location = location
        self.user = user
    }

    /**
     Converts the current information to an itinerary item and saves to the itinerary model.
     */
    func save() throws {
        if let itineraryItem = buildItineraryItem() {
            try itineraryModel.addItineraryItem(itineraryItem: itineraryItem)
        }
    }

    private func buildItineraryItem() -> ItineraryItem? {
        guard let locationId = location.id else {
            return nil
        }
        guard let userUnwrapped = user else {
            return nil
        }
        let imageId = location.imageId
        let itineraryItem = ItineraryItem(locationName: location.name,
                                          locationImageId: imageId,
                                          userId: userUnwrapped.id ?? "",
                                          locationId: locationId,
                                          coordinates: location.coordinates
                                    )
        return itineraryItem
    }
}
