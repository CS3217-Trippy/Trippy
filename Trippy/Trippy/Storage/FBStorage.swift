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

class FBStorage<Storable>: StorageProtocol where Storable: FBStorable {

    var storedItems: Published<[Storable.ModelType]>.Publisher {
        $_storedItems
    }
    @Published private var _storedItems: [Storable.ModelType] = []
    private let store = Firestore.firestore()

    func fetch(handler: (([Storable.ModelType]) -> Void)?) {
        store.collection(Storable.path).addSnapshotListener { snapshot, error in
            if let error = error {
                print(error)
                return
            }
            let result: [Storable.ModelType] = snapshot?.documents.compactMap {
                guard let fbItem = try? $0.data(as: Storable.self) else {
                    return nil
                }
                return fbItem.convertToModelType()
            } ?? []
            if let handler = handler {
                handler(result)
            } else {
                self._storedItems.append(contentsOf: result)
            }
        }
    }

    func fetchWithField(field: String, value: String, handler: (([Storable.ModelType]) -> Void)?) {
        store.collection(Storable.path).whereField(field, isEqualTo: value).addSnapshotListener { snapshot, error in
            if let error = error {
                print(error)
                return
            }
            let result: [Storable.ModelType] = snapshot?.documents.compactMap {
                guard let fbItem = try? $0.data(as: Storable.self) else {
                    return nil
                }
                return fbItem.convertToModelType()
            } ?? []
            if let handler = handler {
                handler(result)
            } else {
                self._storedItems.append(contentsOf: result)
            }
        }
    }

    func fetchWithFieldContainsAny(field: String, value: [String], handler: (([Storable.ModelType]) -> Void)?) {
        store.collection(Storable.path)
            .whereField(field, arrayContainsAny: value)
            .addSnapshotListener { snapshot, error in
            if let error = error {
                print(error)
                return
            }
            let result: [Storable.ModelType] = snapshot?.documents.compactMap {
                guard let fbItem = try? $0.data(as: Storable.self) else {
                    return nil
                }
                return fbItem.convertToModelType()
            } ?? []
            if let handler = handler {
                handler(result)
            } else {
                self._storedItems.append(contentsOf: result)
            }
            }
    }

    func fetchWithFieldOnce(field: String, value: String, handler: (([Storable.ModelType]) -> Void)?) {
        store.collection(Storable.path).whereField(field, isEqualTo: value).getDocuments { snapshot, error in
            if let error = error {
                print(error)
                return
            }
            let result: [Storable.ModelType] = snapshot?.documents.compactMap {
                guard let fbItem = try? $0.data(as: Storable.self) else {
                    return nil
                }
                return fbItem.convertToModelType()
            } ?? []
            if let handler = handler {
                handler(result)
            } else {
                self._storedItems.append(contentsOf: result)
            }
        }
    }

    func fetchWithId(id: String, handler: ((Storable.ModelType) -> Void)?) {
        store.collection(Storable.path).document(id).addSnapshotListener { document, error in
            if let error = error {
                print(error)
                return
            }
            guard let fbItem = try? document?.data(as: Storable.self) else {
                return
            }
            let result = fbItem.convertToModelType()
            if let handler = handler {
                handler(result)
            } else {
                self._storedItems = [result]
                return
            }
        }
    }

    func add(item: Storable.ModelType) {
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
    }

    func update(item: Storable.ModelType) throws {
        let fbItem = Storable(item: item)
        guard let id = fbItem.id else {
            return
        }
        try store.collection(Storable.path).document(id).setData(from: fbItem)
    }

    func remove(item: Storable.ModelType) {
        guard let id = item.id else {
            return
        }
        store.collection(Storable.path).document(id).delete()
    }

    func removeStoredItems() {
        self._storedItems.removeAll()
    }

    typealias StoredType = Storable.ModelType

}
