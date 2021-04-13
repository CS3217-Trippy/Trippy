//
//  UserRelatedStorage.swift
//  Trippy
//
//  Created by Lim Chun Yong on 28/3/21.
//

import Combine

protocol StorageProtocol: ObservableObject {
    associatedtype StoredType

    var storedItems: Published<[StoredType]>.Publisher { get }

    func fetch(handler: (([StoredType]) -> Void)?)

    func fetchWithId(id: String, handler: ((StoredType) -> Void)?)

    func fetchWithField(field: String, value: String, handler: (([StoredType]) -> Void)?)

    func fetchWithFieldContainsAny(field: String, value: [String], handler: (([StoredType]) -> Void)?)

    func fetchWithFieldOnce(field: String, value: String, handler: (([StoredType]) -> Void)?)

    func add(item: StoredType) throws

    func update(item: StoredType) throws

    func remove(item: StoredType)

    func removeStoredItems()
}
