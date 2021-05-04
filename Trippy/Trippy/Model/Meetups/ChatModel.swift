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
        fetchMessages(handler: nil)
    }

    /// Retrieves array of messages for a particular meetup
    func fetchMessages(handler: ((ChatMessage) -> Void)?) {
        guard let id = meetupId else {
            return
        }
        let field = "meetupId"
        let orderBy = "dateSent"
        storage.fetchWithFieldOrderBy(field: field, value: id, orderBy: orderBy, desc: false, handler: handler)
    }

    /// Sends a message
    func sendMessage(message: ChatMessage) throws {
        try storage.add(item: message, handler: nil)
    }

}
