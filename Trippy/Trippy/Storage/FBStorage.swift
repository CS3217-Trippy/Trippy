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
                print(error.localizedDescription)
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
                self._storedItems = result
            }
        }
    }

    func fetchWithFieldOrderBy(field: String, value: String, orderBy: String,
                               desc: Bool, handler: ((StoredType) -> Void)?) {
        store.collection(Storable.path).whereField(field, isEqualTo: value)
            .order(by: orderBy, descending: desc)
            .addSnapshotListener { snapshot, _ in
                snapshot?.documentChanges.forEach { diff in
                    if diff.type == .added {
                        guard let model = try? diff.document.data(as: Storable.self)?.convertToModelType() else {
                            return
                        }
                        if let handler = handler {
                            handler(model)
                        } else {
                            self._storedItems.append(model)
                        }
                    }
                }
            }
    }

    func fetchWithField(field: String, value: String, handler: (([Storable.ModelType]) -> Void)?) {
        store.collection(Storable.path).whereField(field, isEqualTo: value).addSnapshotListener { snapshot, error in
            if let error = error {
                print(error.localizedDescription)
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
                self._storedItems = result
            }
        }
    }

    func fetchWithFieldContainsAny(field: String, value: [String], handler: (([Storable.ModelType]) -> Void)?) {
        guard !value.isEmpty else {
            return
        }
        store.collection(Storable.path)
            .whereField(field, in: value)
            .addSnapshotListener { snapshot, error in
            if let error = error {
                print(error.localizedDescription)
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
                    self._storedItems = result
            }
            }
    }

    func fetchArrayContainsAny(field: String, value: [String], handler: (([Storable.ModelType]) -> Void)?) {
        guard !value.isEmpty else {
            return
        }
        store.collection(Storable.path)
            .whereField(field, arrayContainsAny: value)
            .addSnapshotListener { snapshot, error in
            if let error = error {
                print(error.localizedDescription)
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
                    self._storedItems = result
            }
            }
    }

    func fetchWithFieldNotIn(field: String, value: [String], handler: (([StoredType]) -> Void)?) {
        guard !value.isEmpty else {
            return
        }
        store.collection(Storable.path)
            .whereField(field, notIn: value)
            .addSnapshotListener { snapshot, error in
            if let error = error {
                print(error.localizedDescription)
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
                    self._storedItems = result
            }
            }
    }

    func fetchWithFieldAndDiscard(field: String, value: String, handler: @escaping (([Storable.ModelType]) -> Void)) {
        store.collection(Storable.path).whereField(field, isEqualTo: value).getDocuments { snapshot, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            let result: [Storable.ModelType] = snapshot?.documents.compactMap {
                guard let fbItem = try? $0.data(as: Storable.self) else {
                    return nil
                }
                return fbItem.convertToModelType()
            } ?? []
            handler(result)
        }
    }

    func fetchWithId(id: String, handler: ((Storable.ModelType) -> Void)?) {
        store.collection(Storable.path).document(id).addSnapshotListener { document, error in
            if let error = error {
                print(error.localizedDescription)
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

    func add(item: Storable.ModelType, handler: ((Storable.ModelType) -> Void)?) throws {
        let fbItem = Storable(item: item)
        do {
            if let id = item.id {
                try store.collection(Storable.path).document(id).setData(from: fbItem) { error in
                    if error != nil {
                        return
                    }
                    if let handler = handler {
                        handler(fbItem.convertToModelType())
                    }
                }
            } else {
                item.id = try store.collection(Storable.path).addDocument(from: fbItem).documentID
            }
        } catch {
            throw StorageError.saveFailure
        }
    }

    func update(item: Storable.ModelType, handler: ((Storable.ModelType) -> Void)?) throws {
        let fbItem = Storable(item: item)
        guard let id = fbItem.id else {
            return
        }
        do {
            try store.collection(Storable.path).document(id).setData(from: fbItem) { error in
                guard let handler = handler else {
                    return
                }
                if error == nil {
                    handler(item)
                }
            }
        } catch {
            throw StorageError.saveFailure
        }

    }

    func remove(item: Storable.ModelType) {
        guard let id = item.id else {
            return
        }
        store.collection(Storable.path).document(id).delete()
    }

    func flushLocalItems() {
        self._storedItems.removeAll()
    }

    typealias StoredType = Storable.ModelType

}
