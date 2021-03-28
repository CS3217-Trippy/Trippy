//
//  FBUserRelatedStorage.swift
//  Trippy
//
//  Created by Lim Chun Yong on 28/3/21.
//

import FirebaseFirestore
import FirebaseFirestoreSwift
import Firebase
import Combine

class FBUserRelatedStorage<Storable>: UserRelatedStorage where Storable: FBUserRelatedStorable {
    var storedItems: Published<[Storable.ModelType]>.Publisher {
        $_storedItems
    }
    @Published private var _storedItems: [Storable.ModelType] = []
    private let store = Firestore.firestore()

    func fetch(userId: String) {
        let field = "userId"
        store.collection(Storable.path).whereField(field, isEqualTo: userId).getDocuments { snapshot, error in
            if let error = error {
                print(error)
                return
            }
            self._storedItems = snapshot?.documents.compactMap {
                guard let fbItem = try? $0.data(as: Storable.self) else {
                    return nil
                }
                return fbItem.convertToModelType()
            } ?? []
        }
    }

    func add(item: Storable.ModelType) throws {
        let fbItem = Storable(item: item)
        do {
            if let id = item.id {
                try store.collection(Storable.path).document(id).setData(from: fbItem)
            } else {
                item.id = try store.collection(Storable.path).addDocument(from: fbItem).documentID
            }
        } catch {
            print(error.localizedDescription)
        }
        _storedItems.append(item)
    }

    func update(item: Storable.ModelType) throws {
        let fbItem = Storable(item: item)
        guard let id = fbItem.id else {
            return
        }
        try store.collection(Storable.path).document(id).setData(from: fbItem) { error in
            if let error = error {
                print("Error Updating: \(error.localizedDescription)")
            }
            self._storedItems.removeAll { $0.id == id }
            self._storedItems.append(item)
        }
    }

    func remove(item: Storable.ModelType) {
        guard let id = item.id else {
            return
        }
        store.collection(Storable.path).document(id).delete { error in
            if let error = error {
                print("Error removing document: \(error.localizedDescription)")
            } else {
                self._storedItems.removeAll { $0.id == id }
            }
        }
    }

    typealias StoredType = Storable.ModelType

}
