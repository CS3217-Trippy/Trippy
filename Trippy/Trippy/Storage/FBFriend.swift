import FirebaseFirestoreSwift
import Foundation
struct FBFriend: FBUserRelatedStorable {
    typealias ModelType = Friend
    static var path = "friends"
    @DocumentID var id: String?
    var userId: String
    var username: String
    var userProfilePhoto: String?
    var friendId: String
    var friendUsername: String
    var friendProfilePhoto: String?
    var hasAccepted: Bool

    func convertToModelType() -> ModelType {
        var friendPhoto: URL?
        if let url = friendProfilePhoto {
            friendPhoto = URL(string: url)
        }

        var userPhoto: URL?
        if let url = userProfilePhoto {
            userPhoto = URL(string: url)
        }

        return Friend(
            userId: userId,
            username: username,
            userProfilePhoto: userPhoto,
            friendId: friendId,
            friendUsername: friendUsername,
            friendProfilePhoto: friendPhoto,
            hasAccepted: hasAccepted
        )
    }

    init(item: Friend) {
        self.userId = item.userId
        self.username = item.username
        self.userProfilePhoto = item.userProfilePhoto?.absoluteString
        self.friendId = item.friendId
        self.friendUsername = item.friendUsername
        self.id = item.id
        self.friendUsername = item.friendUsername
        self.friendProfilePhoto = item.friendProfilePhoto?.absoluteString
        self.hasAccepted = item.hasAccepted
    }

}
