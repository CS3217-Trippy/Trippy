import FirebaseFirestore
import FirebaseFirestoreSwift
import Combine

final class BucketItemRepository : ObservableObject {
    private let path = "bucketItems"
    private let store = Firestore.firestore()
    @Published var bucketItems: [BucketItem] = []
    init() {
        get()
    }
    func get() {
        store.collection(path).addSnapshotListener{(snapshot, error) in
            if let error = error {
                return
            }
            self.bucketItems = snapshot?.documents.compactMap{
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


