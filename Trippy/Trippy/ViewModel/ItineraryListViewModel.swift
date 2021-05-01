import Combine
import CoreLocation

/// View model of an itinerary list.
final class ItineraryListViewModel: ObservableObject {
    struct BestRouteResult {
        let route: [ItineraryItem]
        let cost: Double
    }

    private var itineraryModel: ItineraryModel<FBStorage<FBItineraryItem>>
    @Published var itineraryItemViewModels: [ItineraryItemViewModel] = []
    @Published var bestRouteViewModels: [ItineraryItemViewModel] = []
    @Published var bestRouteCost = 0.0
    private let locationModel: LocationModel<FBStorage<FBLocation>>
    private let meetupModel: MeetupModel<FBStorage<FBMeetup>>
    private let imageModel: ImageModel
    private var user: User
    private var locationListViewModel: LocationListViewModel
    private var cancellables: Set<AnyCancellable> = []
    var isEmpty: Bool {
        itineraryItemViewModels.isEmpty
    }

    init (
        itineraryModel: ItineraryModel<FBStorage<FBItineraryItem>>,
        imageModel: ImageModel,
        meetupModel: MeetupModel<FBStorage<FBMeetup>>,
        locationModel: LocationModel<FBStorage<FBLocation>>,
        locationList: LocationListViewModel,
        user: User
    ) {
        self.itineraryModel = itineraryModel
        self.imageModel = imageModel
        self.meetupModel = meetupModel
        self.locationModel = locationModel
        self.locationListViewModel = locationList
        self.user = user
        itineraryModel.$itineraryItems.map { itineraryItem in
            itineraryItem.map { itineraryItem in
                self.constructItemViewModel(itineraryItem: itineraryItem)
            }
        }
        .assign(to: \.itineraryItemViewModels, on: self)
        .store(in: &cancellables)
    }

    /// Fetch itinerary items from the model.
    func fetch() {
        itineraryModel.fetchItineraryItems()
    }

    func getLocationDetailViewModel(locationId: String) -> LocationDetailViewModel? {
        locationListViewModel.getDetailViewModel(locationId: locationId)
    }

    private func constructItemViewModel(itineraryItem: ItineraryItem) -> ItineraryItemViewModel {
        let detailViewModel = self.getLocationDetailViewModel(locationId: itineraryItem.locationId)
        return ItineraryItemViewModel(itineraryItem: itineraryItem,
                               itineraryModel: itineraryModel,
                               imageModel: imageModel,
                               meetupModel: meetupModel,
                               locationModel: locationModel,
                               locationDetailViewModel: detailViewModel,
                               user: user)
    }

    /// Get the best route for the current itinerary.
    func getBestRoute() {
        let result = calculateBestRoute()

        bestRouteViewModels = result.route.map {
            self.constructItemViewModel(itineraryItem: $0)
        }
        bestRouteCost = result.cost
    }

    private func getDistance(indexI: Int, indexJ: Int) -> Double {
        let latitudeI = itineraryItemViewModels[indexI].location?.coordinates.latitude ?? 0.0
        let latitudeJ = itineraryItemViewModels[indexJ].location?.coordinates.latitude ?? 0.0
        let longitudeI = itineraryItemViewModels[indexI].location?.coordinates.longitude ?? 0.0
        let longitudeJ = itineraryItemViewModels[indexJ].location?.coordinates.longitude ?? 0.0
        return CLLocation(latitude: latitudeI, longitude: longitudeI)
            .distance(from: CLLocation(latitude: latitudeJ, longitude: longitudeJ))
    }

    private func calculateBestRoute() -> BestRouteResult {
        let numOfNodes = itineraryItemViewModels.count
        let bestRouteUtil = BestRouteUtil(numOfNodes: numOfNodes)

        if numOfNodes > 1 {
            for i in 0...numOfNodes - 2 {
                for j in i + 1...numOfNodes - 1 {
                    let dist = getDistance(indexI: i, indexJ: j)
                    bestRouteUtil.addEdge(edge: .init(u: i, v: j, weight: dist))
                }
            }
        }

        let result: [Int]

        if numOfNodes > 0 {
            result = bestRouteUtil.getBestRoute()
        } else {
            result = []
        }
        var cost = 0.0

        if numOfNodes > 1 {
            for i in 0...numOfNodes - 2 {
                cost += getDistance(indexI: result[i], indexJ: result[i + 1])
            }
        }

        return .init(route: result.map { itineraryItemViewModels[$0].itineraryItem }, cost: cost)
    }
}
