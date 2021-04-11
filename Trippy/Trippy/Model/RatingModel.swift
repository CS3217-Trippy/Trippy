//
//  RatingModel.swift
//  Trippy
//
//  Created by QL on 10/4/21.
//

import Foundation
import Combine

class RatingModel<Storage: UserRelatedStorage>: ObservableObject where Storage.StoredType == Rating {
    @Published private(set) var ratings: [Rating] = []
    private let storage: Storage
    private var cancellables: Set<AnyCancellable> = []

    init(storage: Storage, recommender: LocationRecommender) {
        self.storage = storage
        storage.storedItems.assign(to: \.ratings, on: self)
            .store(in: &cancellables)
        fetchRatings()
    }
    
    func fetchRatings() {
        storage.fetch()
    }

    func add(rating: Rating) throws {
        guard !ratings.contains(where: { $0.id == rating.id }) else {
            return
        }

        try storage.add(item: rating)
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

        try storage.update(item: updatedRating)
    }

}
