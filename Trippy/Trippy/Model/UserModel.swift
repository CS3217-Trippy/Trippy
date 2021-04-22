import Combine

class UserModel<Storage: StorageProtocol> where Storage.StoredType == User {
    @Published private(set) var users: [User] = []
    private let storage: Storage
    private var cancellables: Set<AnyCancellable> = []

    init(storage: Storage) {
        self.storage = storage
        storage.storedItems.assign(to: \.users, on: self)
            .store(in: &cancellables)
        fetchUsers(handler: nil)
    }

    /// Fetch all users.
    func fetchUsers(handler: (([User]) -> Void)?) {
        storage.fetch(handler: handler)
    }
}
