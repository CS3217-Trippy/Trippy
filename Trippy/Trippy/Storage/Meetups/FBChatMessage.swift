//
//  FBChatMessage.swift
//  Trippy
//
//  Created by Lim Chun Yong on 2/5/21.
//
import FirebaseFirestoreSwift
import Foundation
import CoreLocation

struct FBChatMessage: FBStorable {
    static var path = "meetupChats"
    typealias ModelType = ChatMessage
    @DocumentID var id: String?
    var meetupId: String
    var userId: String
    var message: String
    var dateSent: Date

    init(item: ModelType) {
        id = item.id
        meetupId = item.meetupId
        userId = item.userId
        message = item.message
        dateSent = item.dateSent
    }

    func convertToModelType() -> ChatMessage {
        ChatMessage(id: id, meetupId: meetupId, userId: userId, message: message, dateSent: dateSent)
    }
}
