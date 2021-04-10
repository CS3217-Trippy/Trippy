import FirebaseFirestoreSwift
import Foundation
import UIKit
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
        let friend = Friend(
            userId: userId,
            username: username,
            friendId: friendId,
            friendUsername: friendUsername,
            hasAccepted: hasAccepted
        )
        guard let userProfilePhoto = userProfilePhoto, let friendProfilePhoto = friendProfilePhoto else {
            return friend
        }
        Downloader.getDataFromString(from: userProfilePhoto) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            DispatchQueue.main.async {
                let image = UIImage(data: data)
                friend.userProfilePhoto = image
            }
        }

        Downloader.getDataFromString(from: friendProfilePhoto) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            DispatchQueue.main.async {
                let image = UIImage(data: data)
                friend.friendProfilePhoto = image
            }
        }

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
    }

}
