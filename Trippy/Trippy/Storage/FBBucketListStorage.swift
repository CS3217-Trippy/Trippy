import FirebaseFirestore
import FirebaseFirestoreSwift
import Combine

final class FBBucketListStorage: BucketListStorage, ObservableObject {
    var bucketList: Published<[BucketItem]>.Publisher {
        $_bucketItems
    }
    private let path = "bucketItems"
    private let store = Firestore.firestore()
    private let userId: String
    @Published private var _bucketItems: [BucketItem] = []

    init(user: User?) {
        if let userId = user?.id {
            self.userId = userId
            self.fetchBucketItems()
        } else {
            self.userId = ""
        }
    }

    func fetchBucketItems() {
        let field = "userId"
        let sortField = "dateAdded"
        store.collection(path).whereField(field, isEqualTo: userId)
            .order(by: sortField).getDocuments {query, error in
            if error != nil {
                return
            }
            self._bucketItems = query?.documents.compactMap {
                let fbBucket = try? $0.data(as: FBBucketItem.self)
                guard let bucket = fbBucket else {
                    return nil
                }
                return self.convertFBBucketListToBucketList(bucketItem: bucket)
            } ?? []
            }
    }

    func addBucketItem(bucketItem: BucketItem) throws {
        do {
            let FBBucketItem = convertBucketItemToFBBucketItem(bucketItem: bucketItem)
            try store.collection(path).document(bucketItem.id).setData(from: FBBucketItem)
        } catch {
            throw StorageError.saveFailure
        }
        _bucketItems.append(bucketItem)
    }

    func updateBucketItem(bucketItem: BucketItem) throws {
        let fbItem = convertBucketItemToFBBucketItem(bucketItem: bucketItem)
        let documentId = bucketItem.id
        do {
            try store.collection(path).document(documentId).setData(from: fbItem)
        } catch {
            throw StorageError.saveFailure
        }
        _bucketItems.removeAll { $0.id == bucketItem.id }
        _bucketItems.append(bucketItem)
    }

    func removeBucketItem(bucketItem: BucketItem) {
        let documentId = bucketItem.id
        store.collection(path).document(documentId).delete()
        _bucketItems.removeAll { $0.id == bucketItem.id }
    }

    private func convertBucketItemToFBBucketItem(bucketItem: BucketItem) -> FBBucketItem {
        FBBucketItem(id: bucketItem.id,
                     locationName: bucketItem.locationName,
                     locationImage: bucketItem.locationImage?.absoluteString,
                     userId: bucketItem.userId,
                     locationId: bucketItem.locationId,
                     dateVisited: bucketItem.dateVisited,
                     dateAdded: bucketItem.dateAdded,
                     userDescription: bucketItem.userDescription
                     )
    }

    private func convertFBBucketListToBucketList(bucketItem: FBBucketItem) -> BucketItem {
        var image: URL?
        if let url = bucketItem.locationImage {
            image = URL(string: url)
        }
        return BucketItem(locationName: bucketItem.locationName,
                          locationImage: image,
                          userId: bucketItem.userId,
                          locationId: bucketItem.locationId,
                          dateVisited: bucketItem.dateVisited,
                          dateAdded: bucketItem.dateAdded,
                          userDescription: bucketItem.userDescription
        )
    }
}
