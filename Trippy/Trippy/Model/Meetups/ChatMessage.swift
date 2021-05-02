import Foundation

class ChatMessage: Model {
    var id: String?
    var meetupId: String
    var userId: String
    var message: String
    var dateSent: Date

    init(id: String?, meetupId: String, userId: String, message: String, dateSent: Date) {
        self.id = id
        self.meetupId = meetupId
        self.userId = userId
        self.message = message
        self.dateSent = dateSent
    }
}
