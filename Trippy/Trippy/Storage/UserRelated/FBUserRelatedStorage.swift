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
    var userId: String?
    var storedItems: Published<[Storable.ModelType]>.Publisher {
        $_storedItems
    }
    @Published private var _storedItems: [Storable.ModelType] = []
    private let store = Firestore.firestore()

    init(userId: String?) {
        self.userId = userId
    }

    func fetch() {
        guard let userId = userId else {
            return
        }
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

    func fetchWithField(field: String, handler: (([Storable.ModelType]) -> Void)?) {
        guard let userId = userId else {
            return
        }
        store.collection(Storable.path).whereField(field, isEqualTo: userId).getDocuments { snapshot, error in
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
                self._storedItems = result
            }
        }
    }

    func fetchWithId(id: String, handler: ((Storable.ModelType) -> Void)?) {
        store.collection(Storable.path).document(id).getDocument { document, error in
            if let error = error {
                print(error)
                return
            }
            guard let fbItem = try? document?.data(as: Storable.self) else {
                return
            }
            guard let handler = handler else {
                self._storedItems = []
                self._storedItems.append(fbItem.convertToModelType())
                return
            }
            handler(fbItem.convertToModelType())
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
        if item.userId == userId {
            _storedItems.append(item)
        }
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
