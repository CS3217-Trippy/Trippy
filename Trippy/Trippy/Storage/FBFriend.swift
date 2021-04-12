import FirebaseFirestoreSwift
import Foundation
import UIKit
struct FBFriend: FBStorable {
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
        let friend = Friend(
            userId: userId,
            username: username,
            userProfilePhoto: userProfilePhoto,
            friendId: friendId,
            friendUsername: friendUsername,
            friendProfilePhoto: friendProfilePhoto,
            hasAccepted: hasAccepted
        )
        return friend
    }

    init(item: Friend) {
        self.userId = item.userId
        self.username = item.username
        self.friendId = item.friendId
        self.friendUsername = item.friendUsername
        self.id = item.id
        self.friendUsername = item.friendUsername
        self.hasAccepted = item.hasAccepted
        self.friendProfilePhoto = item.friendProfilePhoto
        self.userProfilePhoto = item.userProfilePhoto
    }

}
