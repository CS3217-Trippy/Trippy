import FirebaseFirestore
import FirebaseFirestoreSwift
import Combine

final class BucketItemStorage : ObservableObject {
    private let path = "bucketItems"
    private let store = Firestore.firestore()
    @Published var bucketItems: [BucketItem] = []
    init() {
        get()
    }
    func get() {
        store.collection(path).getDocuments{(query, error) in
            if error != nil {
                return
            }
            self.bucketItems = query?.documents.compactMap{
                try? $0.data(as: BucketItem.self)
            } ?? []
        }
    }
    func add(item: BucketItem) {
        do {
            try store.collection(path).addDocument(from: item)
        } catch {
            return
        }
    }
}

