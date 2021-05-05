import Combine

class MeetupNotificationModel<Storage: StorageProtocol>: ObservableObject
where Storage.StoredType == MeetupNotification {
    @Published private(set) var notifications: [MeetupNotification] = []
    private let userId: String?
    private let storage: Storage
    private var cancellables: Set<AnyCancellable> = []

    init(storage: Storage, userId: String?) {
        self.userId = userId
        self.storage = storage
        storage.storedItems.assign(to: \.notifications, on: self)
            .store(in: &cancellables)
        fetchNotifications()
    }

    private func fetchNotifications() {
        guard let id = userId else {
            return
        }
        let field = "userId"
        storage.fetchWithField(field: field, value: id) { notifications in
            self.notifications = notifications
        }
    }

    func addNotification(item: MeetupNotification) throws {
        try storage.add(item: item, handler: nil)
    }

    func updateNotification(item: MeetupNotification) throws {
        try storage.update(item: item, handler: nil)
    }

}
