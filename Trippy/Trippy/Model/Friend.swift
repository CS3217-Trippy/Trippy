import Foundation
class Friend: UserRelatedModel {
    var id: String?
    private(set) var userId: String
    private(set) var username: String
    private(set) var userProfilePhoto: URL?
    private(set) var friendId: String
    private(set) var friendUsername: String
    private(set) var friendProfilePhoto: URL?
    private(set) var hasAccepted: Bool

    init(userId: String,
         username: String,
         userProfilePhoto: URL?,
         friendId: String,
         friendUsername: String,
         friendProfilePhoto: URL?,
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
