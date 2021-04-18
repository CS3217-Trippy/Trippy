//
//  RatingModel.swift
//  Trippy
//
//  Created by QL on 10/4/21.
//

import Foundation
import Combine

class RatingModel<Storage: StorageProtocol>: ObservableObject where Storage.StoredType == Rating {
    @Published private(set) var ratings: [Rating] = []
    private let storage: Storage
    private var cancellables: Set<AnyCancellable> = []

    init(storage: Storage) {
        self.storage = storage
        storage.storedItems.assign(to: \.ratings, on: self)
            .store(in: &cancellables)
        fetchRatings()
    }

    func fetchRatings() {
        storage.fetch(handler: nil)
    }

    func add(rating: Rating) throws {
        guard !ratings.contains(where: { $0.id == rating.id }) else {
            return
        }

        try storage.add(item: rating, handler: nil)
    }

    func remove(rating: Rating) {
        guard ratings.contains(where: { $0.id == rating.id }) else {
            return
        }

        storage.remove(item: rating)
    }

    func updateRating(updatedRating: Rating) throws {
        guard ratings.contains(where: { $0.id == updatedRating.id }) else {
            return
        }

        try storage.update(item: updatedRating, handler: nil)
    }

    func getAverageRating(for location: Location) -> Float? {
        let filteredRatings = ratings.filter { $0.locationId == location.id }
        if filteredRatings.isEmpty {
            return nil
        }
        return Float(filteredRatings.reduce(0, { $0 + $1.score })) / Float(filteredRatings.count)
    }
}
