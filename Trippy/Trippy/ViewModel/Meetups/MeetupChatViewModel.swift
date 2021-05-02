//
//  MeetupChatViewModel.swift
//  Trippy
//
//  Created by Lim Chun Yong on 2/5/21.
//

import Combine
import Foundation
import UIKit

final class MeetupChatViewModel: ObservableObject, Identifiable {
    private var meetupItem: Meetup
    private var location: Location?
    var image: UIImage?
    private var chatModel: ChatModel<FBStorage<FBChatMessage>>
    private var cancellables: Set<AnyCancellable> = []
    @Published var messages: [ChatMessageViewModel] = []
    var locationName: String {
        location?.name ?? ""
    }

    var meetupDate: String {
        meetupItem.meetupDate.dateStringFromDate
    }

    init(meetupItem: Meetup, chatModel: ChatModel<FBStorage<FBChatMessage>>, location: Location?, image: UIImage?) {
        self.meetupItem = meetupItem
        self.location = location
        self.image = image
        self.chatModel = chatModel

        chatModel.$messages.map { messages in
           var arr = messages.filter { $0.meetupId == meetupItem.id }.map {
                ChatMessageViewModel(message: $0)
           }
            arr.sort {
                $0.dateSent < $1.dateSent
            }
            return arr
        }.assign(to: \.messages, on: self)
        .store(in: &cancellables)
         chatModel.fetchMessages()
    }

    func sendMessage(message: String, user: User?) throws {
        let message = buildChatMessage(message: message, user: user)
        guard let chatMessage = message else {
            return
        }
        try chatModel.sendMessage(message: chatMessage)
    }

    private func buildChatMessage(message: String, user: User?) -> ChatMessage? {
        guard let userId = user?.id, let meetupId = meetupItem.id else {
            return nil
        }
        return ChatMessage(id: nil, meetupId: meetupId, userId: userId, message: message, dateSent: Date())
    }

}
