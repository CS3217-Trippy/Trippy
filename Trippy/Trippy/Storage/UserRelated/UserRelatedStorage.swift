//
//  UserRelatedStorage.swift
//  Trippy
//
//  Created by Lim Chun Yong on 28/3/21.
//

import Combine

protocol UserRelatedStorage: ObservableObject {
    associatedtype StoredType

    var storedItems: Published<[StoredType]>.Publisher { get }

    func fetch(userId: String)

    func add(item: StoredType) throws

    func update(item: StoredType) throws

    func remove(item: StoredType)
}
