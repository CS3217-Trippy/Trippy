//
//  AchievementModel.swift
//  Trippy
//
//  Created by Audrey Felicio Anwar on 13/4/21.
//

import Combine

class AchievementModel<Storage: StorageProtocol>: ObservableObject where Storage.StoredType == Achievement {
    @Published private(set) var achievements: [Achievement] = []
    private let storage: Storage
    private var cancellables: Set<AnyCancellable> = []

    init(storage: Storage) {
        self.storage = storage
        storage.storedItems.assign(to: \.achievements, on: self)
            .store(in: &cancellables)
        fetchAchievements()
    }

    private func fetchAchievements() {
        storage.fetch(handler: nil)
    }
}
