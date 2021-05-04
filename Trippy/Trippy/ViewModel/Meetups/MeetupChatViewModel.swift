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
    @Published var location: Location?
    @Published var image: UIImage?
    var imageModel: ImageModel
    private var chatModel: ChatModel<FBStorage<FBChatMessage>>
    private var cancellables: Set<AnyCancellable> = []
    private let locationModel: LocationModel<FBStorage<FBLocation>>
    @Published var messages: [ChatMessageViewModel] = []
    @Published var detailViewModel: LocationDetailViewModel?

    var locationName: String {
        location?.name ?? ""
    }

    var meetupDate: String {
        meetupItem.meetupDate.dateStringFromDate
    }

    init(meetupItem: Meetup,
         chatModel: ChatModel<FBStorage<FBChatMessage>>,
         imageModel: ImageModel,
         locationModel: LocationModel<FBStorage<FBLocation>>,
         detailViewModel: LocationDetailViewModel?) {
        self.detailViewModel = detailViewModel
        self.locationModel = locationModel
        self.meetupItem = meetupItem
        self.chatModel = chatModel
        self.imageModel = imageModel

        chatModel.$messages.map {messages in
            messages.map {
                ChatMessageViewModel(message: $0)
            }
        }.assign(to: &$messages)
         chatModel.fetchMessages()
        locationModel.fetchLocationWithId(id: meetupItem.locationId, handler: fetchLocation)
    }

    private func fetchLocation(location: Location) {
        if let id = location.imageId {
            imageModel.fetch(ids: [id]) { images in
                if !images.isEmpty {
                    self.image = images[0]
                }
            }
        }
        self.location = location
    }

    func sendMessage(message: String, user: User?) throws {
        let trimmed = message.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.isEmpty {
            return
        }
        let message = buildChatMessage(message: trimmed, user: user)
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
