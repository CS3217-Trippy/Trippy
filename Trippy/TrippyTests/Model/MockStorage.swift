//
//  MockStorage.swift
//  TrippyTests
//
//  Created by Lim Chun Yong on 17/4/21.
//

@testable import Trippy
import Combine

class MockStorage<Storable>: StorageProtocol where Storable: FBStorable {

    var storedItems: Published<[Storable.ModelType]>.Publisher {
        $_storedItems
    }
    @Published private var _storedItems: [Storable.ModelType] = []

    func fetch(handler: (([Storable.ModelType]) -> Void)?) {
        if let handler = handler {
            handler(_storedItems)
        }
    }

    func fetchWithField(field: String, value: String, handler: (([Storable.ModelType]) -> Void)?) {
        if let handler = handler {
            handler(_storedItems)
        }
    }

    func fetchWithFieldContainsAny(field: String, value: [String], handler: (([Storable.ModelType]) -> Void)?) {
        if let handler = handler {
            handler(_storedItems)
        }
    }

    func fetchWithFieldOnce(field: String, value: String, handler: (([Storable.ModelType]) -> Void)?) {
        if let handler = handler {
            handler(_storedItems)
        }
    }

    func fetchWithId(id: String, handler: ((Storable.ModelType) -> Void)?) {
        if let handler = handler {
            let item = _storedItems.last { $0.id == id }
            if let item = item {
                handler(item)
            }
        }
    }

    func add(item: Storable.ModelType) {
        _storedItems.append(item)
    }

    func update(item: Storable.ModelType, handler: ((Storable.ModelType) -> Void)?) throws {
        _storedItems.removeAll { $0.id == item.id }
        _storedItems.append(item)
    }

    func remove(item: Storable.ModelType) {
        _storedItems.removeAll { $0.id == item.id }
    }

    func removeStoredItems() {
        self._storedItems.removeAll()
    }

    typealias StoredType = Storable.ModelType

}
