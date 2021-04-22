import FirebaseFirestoreSwift
import Foundation

struct FBFriend: FBStorable {
    typealias ModelType = Friend
    static var path = "friends"
    @DocumentID var id: String?
    var userId: String
    var friendId: String
    var hasAccepted: Bool

    func convertToModelType() -> ModelType {
        let friend = Friend(
            userId: userId,
            friendId: friendId,
            hasAccepted: hasAccepted
        )
        return friend
    }

    init(item: Friend) {
        self.userId = item.userId
        self.friendId = item.friendId
        self.id = item.id
        self.hasAccepted = item.hasAccepted
    }

}
