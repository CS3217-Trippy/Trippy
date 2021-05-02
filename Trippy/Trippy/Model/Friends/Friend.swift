import Foundation
import UIKit

class Friend: Model {
    var id: String?
    private(set) var userId: String
    private(set) var friendId: String
    private(set) var hasAccepted: Bool

    init(userId: String,
         friendId: String,
         hasAccepted: Bool) {
        self.id = userId + friendId
        self.userId = userId
        self.friendId = friendId
        self.hasAccepted = hasAccepted
    }

    func accept() {
        hasAccepted = true
    }
}
