import Combine

/// View model of an itinerary list.
final class ItineraryListViewModel: ObservableObject {
    private var itineraryModel: ItineraryModel<FBStorage<FBItineraryItem>>
    @Published var itineraryItemViewModels: [ItineraryItemViewModel] = []
    @Published var bestRouteViewModels: [ItineraryItemViewModel] = []
    @Published var bestRouteCost = 0.0
    private let meetupModel: MeetupModel<FBStorage<FBMeetup>>
    private let imageModel: ImageModel
    private var cancellables: Set<AnyCancellable> = []
    var isEmpty: Bool {
        itineraryItemViewModels.isEmpty
    }

    init(
        itineraryModel: ItineraryModel<FBStorage<FBItineraryItem>>,
        imageModel: ImageModel,
        meetupModel: MeetupModel<FBStorage<FBMeetup>>
    ) {
        self.itineraryModel = itineraryModel
        self.imageModel = imageModel
        self.meetupModel = meetupModel
        itineraryModel.$itineraryItems.map { itineraryItem in
            itineraryItem.map { itineraryItem in
                ItineraryItemViewModel(itineraryItem: itineraryItem,
                                       itineraryModel: itineraryModel,
                                       imageModel: imageModel,
                                       meetupModel: meetupModel)
            }
        }
        .assign(to: \.itineraryItemViewModels, on: self)
        .store(in: &cancellables)
    }

    /// Fetch itinerary items from the model.
    func fetch() {
        itineraryModel.fetchItineraryItems()
    }

    /// Get the best route for the current itinerary.
    func getBestRoute() {
        let result = itineraryModel.getBestRoute()

        bestRouteViewModels = result.route.map {
                        ItineraryItemViewModel(itineraryItem: $0,
                                               itineraryModel: itineraryModel,
                                               imageModel: imageModel,
                                               meetupModel: meetupModel)
        }
        bestRouteCost = result.cost
    }

}
