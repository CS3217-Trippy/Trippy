import Foundation
import UIKit

class Friend: Model {
    var id: String?
    private(set) var userId: String
    var username: String
    var userProfilePhoto: String?
    private(set) var friendId: String
    var friendUsername: String
    var friendProfilePhoto: String?
    private(set) var hasAccepted: Bool

    init(userId: String,
         username: String,
         userProfilePhoto: String?,
         friendId: String,
         friendUsername: String,
         friendProfilePhoto: String?,
         hasAccepted: Bool) {
        self.id = userId + friendId
        self.userId = userId
        self.username = username
        self.userProfilePhoto = userProfilePhoto
        self.friendId = friendId
        self.friendUsername = friendUsername
        self.friendProfilePhoto = friendProfilePhoto
        self.hasAccepted = hasAccepted
    }
}
