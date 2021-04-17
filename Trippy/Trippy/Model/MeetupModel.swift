//
//  MeetupModel.swift
//  Trippy
//
//  Created by Lim Chun Yong on 12/4/21.
//

import Combine

class MeetupModel<Storage: StorageProtocol>: ObservableObject where Storage.StoredType == Meetup {
    @Published private(set) var meetupItems: [Meetup] = []
    @Published private(set) var publicMeetupItems: [Meetup] = []
    private let storage: Storage
    private var cancellables: Set<AnyCancellable> = []
    private let userId: String?

    init(storage: Storage, userId: String?) {
        self.storage = storage
        self.userId = userId
        storage.storedItems.assign(to: \.meetupItems, on: self)
            .store(in: &cancellables)
    }

   func fetchMeetups() {
    guard let userId = userId else {
        return
    }
    resetMeetups()
    fetchPublicMeetups()
    fetchMeetupsHostedByUser(userId: userId)
    fetchMeetupsJoinedByUser(userId: userId)
   }

    func addMeetup(meetup: Meetup) throws {
        try storage.add(item: meetup)
    }

    func updateMeetup(meetup: Meetup) throws {
        try storage.update(item: meetup, handler: nil)
    }

    func removeMeetup(meetup: Meetup) {
        storage.remove(item: meetup)
    }

    private func resetMeetups() {
        self.publicMeetupItems = []
        self.meetupItems = []
    }

    private func fetchMeetupsHostedByUser(userId: String) {
        let field = "hostUserId"
        storage.fetchWithField(field: field, value: userId) { meetups in
            self.meetupItems.removeAll { $0.hostUserId == userId }
            self.meetupItems.append(contentsOf: meetups)
        }
    }

    private func fetchMeetupsJoinedByUser(userId: String) {
        let usersField = "userIds"
        storage.fetchWithFieldContainsAny(field: usersField, value: [userId]) { meetups in
            self.meetupItems.removeAll { $0.hostUserId != userId }
            self.meetupItems.append(contentsOf: meetups)
        }
    }

    private func fetchPublicMeetups() {
        let publicField = "meetupPrivacy"
        let value = MeetupPrivacy.publicMeetup.rawValue
        storage.fetchWithField(field: publicField, value: value) { meetups in
            self.publicMeetupItems = meetups
        }
    }

}
