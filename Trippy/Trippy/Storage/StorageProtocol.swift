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

    func fetchWithFieldOrderBy(field: String, value: String, orderBy: String, handler: (([StoredType]) -> Void)?)

    func fetchWithId(id: String, handler: ((StoredType) -> Void)?)

    func fetchWithField(field: String, value: String, handler: (([StoredType]) -> Void)?)

    func fetchWithFieldContainsAny(field: String, value: [String], handler: (([StoredType]) -> Void)?)

    func fetchArrayContainsAny(field: String, value: [String], handler: (([StoredType]) -> Void)?)

    func fetchWithFieldNotIn(field: String, value: [String], handler: (([StoredType]) -> Void)?)

    func fetchWithFieldAndDiscard(field: String, value: String, handler: @escaping (([StoredType]) -> Void))

    func add(item: StoredType, handler: ((StoredType) -> Void)?) throws

    func update(item: StoredType, handler: ((StoredType) -> Void)?) throws

    func remove(item: StoredType)

    func flushLocalItems()
}
