import Combine

class ChatModel<Storage: StorageProtocol>: ObservableObject where Storage.StoredType == ChatMessage {
    @Published private(set) var messages: [ChatMessage] = []
    private let meetupId: String?
    private let storage: Storage
    private var cancellables: Set<AnyCancellable> = []

    init(storage: Storage, meetupId: String?) {
        self.meetupId = meetupId
        self.storage = storage
        storage.storedItems.assign(to: \.messages, on: self)
            .store(in: &cancellables)
        fetchMessages()
    }

    func fetchMessages() {
        guard let id = meetupId else {
            return
        }
        let field = "meetupId"
        storage.fetchWithField(field: field, value: id, handler: nil)
    }

    func sendMessage(message: ChatMessage) throws {
        try storage.add(item: message, handler: nil)
    }

}
