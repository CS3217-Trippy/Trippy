//
//  VisitModel.swift
//  Trippy
//
//  Created by QL on 17/4/21.
//

import Combine
import UIKit

class VisitModel<Storage: StorageProtocol>: ObservableObject where Storage.StoredType == Visit {
    @Published private(set) var visits: [Visit] = []
    private let storage: Storage
    let userId: String?
    private var cancellables: Set<AnyCancellable> = []

    init(storage: Storage, userId: String) {
        self.userId = userId
        self.storage = storage
        storage.storedItems.assign(to: \.visits, on: self)
            .store(in: &cancellables)
        fetch()
    }

    func fetch() {
        guard let userId = userId else {
            return
        }
        let field = "userId"
        storage.fetchWithField(field: field, value: userId, handler: nil)
    }

    func add(_ visit: Visit) throws {
        guard !visits.contains(where: { $0.id == visit.id }) else {
            return
        }
        try storage.add(item: visit, handler: nil)
    }

    func remove(_ visit: Visit) {
        guard visits.contains(where: { $0.id == visit.id }) else {
            return
        }
        storage.remove(item: visit)
    }

    func update(newVisit: Visit) throws {
        guard visits.contains(where: { $0.id == newVisit.id }) else {
            return
        }
        try storage.update(item: newVisit, handler: nil)
    }
}
