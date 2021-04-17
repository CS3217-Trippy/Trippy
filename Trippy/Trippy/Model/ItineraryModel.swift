/**
 Model of the itinerary.
 */
import Combine
import CoreLocation

class ItineraryModel<Storage: StorageProtocol>: ObservableObject where Storage.StoredType == ItineraryItem {
    @Published private(set) var itineraryItems: [ItineraryItem] = []
    private let storage: Storage
    private var cancellables: Set<AnyCancellable> = []
    private let userId: String?

    init(storage: Storage, userId: String?) {
        self.storage = storage
        self.userId = userId
        storage.storedItems.assign(to: \.itineraryItems, on: self)
            .store(in: &cancellables)
        fetchItineraryItems()
    }
    
    /**
     Fetchs itinerary items from the storage.
     */
    func fetchItineraryItems() {
        guard let userId = userId else {
            return
        }
        let field = "userId"
        storage.fetchWithField(field: field, value: userId, handler: nil)
    }
    
    /**
    Add itinerary item to the storage.
     */
    func addItineraryItem(itineraryItem: ItineraryItem) throws {
        guard !itineraryItems.contains(where: { $0.id == itineraryItem.id }) else {
            return
        }
        try storage.add(item: itineraryItem)
    }

    /**
     Remove itinerary item from the storage.
     */
    func removeItineraryItem(itineraryItem: ItineraryItem) {
        guard itineraryItems.contains(where: { $0.id == itineraryItem.id }) else {
            return
        }
        storage.remove(item: itineraryItem)
    }

    /**
     Update itinerary item from the storage.
     */
    func updateItineraryItem(itineraryItem: ItineraryItem) throws {
        guard itineraryItems.contains(where: { $0.id == itineraryItem.id }) else {
            return
        }
        try storage.update(item: itineraryItem, handler: nil)
    }

    private func getDistance(indexI: Int, indexJ: Int) -> Double {
        CLLocation(latitude: itineraryItems[indexI].coordinates.latitude,
                              longitude: itineraryItems[indexI].coordinates.longitude)
            .distance(from: CLLocation(latitude: itineraryItems[indexJ].coordinates.latitude,
                                       longitude: itineraryItems[indexJ].coordinates.longitude))
    }
    
    /**
     Get the best route for the current itinerary,
     */
    func getBestRoute() -> BestRouteResult {
        let numOfNodes = itineraryItems.count
        let bestRouteUtil = BestRouteUtil(numOfNodes: numOfNodes)

        for i in 0...numOfNodes - 2 {
            for j in i + 1...numOfNodes - 1 {
                let dist = getDistance(indexI: i, indexJ: j)
                bestRouteUtil.addEdge(edge: .init(u: i, v: j, weight: dist))
            }
        }

        let result = bestRouteUtil.getBestRoute()
        var cost = 0.0

        for i in 0...numOfNodes - 2 {
            cost += getDistance(indexI: result[i], indexJ: result[i + 1])
        }

        return .init(route: result.map { itineraryItems[$0] }, cost: cost)
    }
}

struct BestRouteResult {
    let route: [ItineraryItem]
    let cost: Double
}
