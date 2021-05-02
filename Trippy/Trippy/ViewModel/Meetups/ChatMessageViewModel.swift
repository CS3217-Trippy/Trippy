import Combine
import Foundation
import UIKit

final class ChatMessageViewModel: ObservableObject, Identifiable {
    private var chatMessage: ChatMessage
    @Published var username: String = ""
    private var userModel = UserModel(storage: FBStorage<FBUser>())

    init(message: ChatMessage) {
        self.chatMessage = message
        userModel.fetchSpecificUser(userId: chatMessage.userId, handler: fetchSender)
    }

    private func fetchSender(user: User) {
        self.username = user.username
    }

    var message: String {
        chatMessage.message
    }

    var dateSent: Date {
        chatMessage.dateSent
    }

    func isCurrentUser(userId: String?) -> Bool {
        guard let id = userId else {
            return false
        }
        return chatMessage.userId == id
    }

}
