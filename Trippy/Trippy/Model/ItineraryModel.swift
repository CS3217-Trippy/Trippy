import Combine
import CoreLocation

/// Model of the itinerary.
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

    /// Fetchs itinerary items from the storage.
    func fetchItineraryItems() {
        guard let userId = userId else {
            return
        }
        let field = "userId"
        storage.fetchWithField(field: field, value: userId, handler: nil)
    }

    /// Add itinerary item to the storage.
    func addItineraryItem(itineraryItem: ItineraryItem) throws {
        guard !itineraryItems.contains(where: { $0.id == itineraryItem.id }) else {
            return
        }
        try storage.add(item: itineraryItem, handler: nil)
    }

    /// Remove itinerary item from the storage.
    func removeItineraryItem(itineraryItem: ItineraryItem) {
        guard itineraryItems.contains(where: { $0.id == itineraryItem.id }) else {
            return
        }
        storage.remove(item: itineraryItem)
    }

    /// Update itinerary item from the storage.
    func updateItineraryItem(itineraryItem: ItineraryItem) throws {
        guard itineraryItems.contains(where: { $0.id == itineraryItem.id }) else {
            return
        }
        try storage.update(item: itineraryItem, handler: nil)
    }
}
