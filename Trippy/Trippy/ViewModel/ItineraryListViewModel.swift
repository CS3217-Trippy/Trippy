import Combine

final class ItineraryListViewModel: ObservableObject {
    private var itineraryModel: ItineraryModel<FBStorage<FBItineraryItem>>
    @Published var itineraryItemViewModels: [ItineraryItemViewModel] = []
    @Published var bestRouteViewModels: [ItineraryItemViewModel] = []
    @Published var bestRouteCost = 0.0
    private let imageModel: ImageModel
    private var cancellables: Set<AnyCancellable> = []
    var isEmpty: Bool {
        itineraryItemViewModels.isEmpty
    }

    init(itineraryModel: ItineraryModel<FBStorage<FBItineraryItem>>, imageModel: ImageModel) {
        self.itineraryModel = itineraryModel
        self.imageModel = imageModel
        itineraryModel.$itineraryItems.map { itineraryItem in
            itineraryItem.map { itineraryItem in
                ItineraryItemViewModel(itineraryItem: itineraryItem,
                                       itineraryModel: itineraryModel,
                                       imageModel: imageModel)
            }
        }
        .assign(to: \.itineraryItemViewModels, on: self)
        .store(in: &cancellables)
    }

    func fetch() {
        itineraryModel.fetchItineraryItems()
    }

    func getBestRoute() {
        let result = itineraryModel.getBestRoute()

        bestRouteViewModels = result.route.map {
                        ItineraryItemViewModel(itineraryItem: $0,
                                               itineraryModel: itineraryModel,
                                               imageModel: imageModel)
        }
        bestRouteCost = result.cost
    }

}
