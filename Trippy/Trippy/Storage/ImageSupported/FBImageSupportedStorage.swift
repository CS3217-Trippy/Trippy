//
//  FBStorage.swift
//  Trippy
//
//  Created by QL on 24/3/21.
//

import FirebaseFirestore
import FirebaseFirestoreSwift
import Firebase
import Combine
import UIKit

class FBImageSupportedStorage<Storable>: ImageSupportedStorage where Storable: FBImageSupportedStorable {
    var storedItems: Published<[Storable.ModelType]>.Publisher {
        $_storedItems
    }
    @Published private var _storedItems: [Storable.ModelType] = []
    private let store = Firestore.firestore()
    private let imageStorage = Firebase.Storage.storage()

    func fetch() {
        store.collection(Storable.path).getDocuments { snapshot, error in
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

    func add(_ item: Storable.ModelType, with image: UIImage?) {
        guard let image = image else {
            self.addDocument(from: item)
            return
        }

        let imageRef = imageStorage.reference().child(UUID().uuidString + ".jpeg")
        addImage(image: image, imageRef: imageRef) { _, error in
            if let error = error {
                print("Error during storing of image: \(error.localizedDescription)")
            }

            imageRef.downloadURL { url, error in
                if let error = error {
                    print("Error during retrieval of image url: \(error.localizedDescription)")
                }
                item.imageURL = url
                self.addDocument(from: item)
            }
        }
    }

    private func addDocument(from item: Storable.ModelType) {
        let fbItem = Storable(item: item)
        do {
            item.id = try store.collection(Storable.path).addDocument(from: fbItem).documentID
        } catch {
            print(error.localizedDescription)
        }
        _storedItems.append(item)
    }

    private func addImage(image: UIImage, imageRef: StorageReference,
                          completion: ((StorageMetadata?, Error?) -> Void)?) {
        guard let data = image.jpegData(compressionQuality: 0.1) else {
            return
        }
        imageRef.putData(data, metadata: nil, completion: completion)
    }

    func update(_ item: Storable.ModelType, with image: UIImage? = nil) throws {
        guard let image = image else {
            self.updateDocument(from: item)
            return
        }

        let imageRef = imageStorage.reference().child(UUID().uuidString + ".jpeg")
        addImage(image: image, imageRef: imageRef) { _, error in
            if let error = error {
                print("Error during storing of image: \(error.localizedDescription)")
            }

            imageRef.downloadURL { url, error in
                if let error = error {
                    print("Error during retrieval of image url: \(error.localizedDescription)")
                }
                let oldUrl = item.imageURL
                item.imageURL = url
                self.updateDocument(from: item) { error in
                    if error != nil {
                        return
                    }
                    if let urlString = oldUrl?.absoluteString {
                        self.deleteImage(url: urlString)
                    }
                }
            }
        }
    }

    private func updateDocument(from item: Storable.ModelType, completion: ((Error?) -> Void)? = nil) {
        let fbItem = Storable(item: item)
        guard let id = fbItem.id else {
            return
        }
        do {
            try store.collection(Storable.path).document(id).setData(from: fbItem) { error in
                if let error = error {
                    print("Error Updating: \(error.localizedDescription)")
                } else {
                    self._storedItems.removeAll { $0.id == item.id }
                    self._storedItems.append(item)
                }
                guard let completion = completion else {
                    return
                }
                completion(error)
            }
        } catch {
            print("Error in writing to firestore: \(error.localizedDescription)")
        }

    }

    func remove(_ item: Storable.ModelType) {
        guard let id = item.id else {
            return
        }
        store.collection(Storable.path).document(id).delete { error in
            if let error = error {
                print("Error removing document: \(error.localizedDescription)")
            } else {
                if let url = item.imageURL?.absoluteString {
                    self.deleteImage(url: url)
                }
                self._storedItems.removeAll { $0.id == item.id }
            }
        }
    }

    private func deleteImage(url: String) {
        self.imageStorage.reference(forURL: url).delete()
    }
}
