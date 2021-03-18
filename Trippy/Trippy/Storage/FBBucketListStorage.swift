import FirebaseFirestore
import FirebaseFirestoreSwift
import Combine

final class FBBucketListStorage: BucketListStorage, ObservableObject {
    var bucketList: Published<[BucketItem]>.Publisher {
        $bucketItems
    }
    private let path = "bucketItems"
    private let store = Firestore.firestore()
    @Published private var bucketItems: [BucketItem] = []

    init() {
        fetchBucketItems()
    }

    func fetchBucketItems() {
        store.collection(path).getDocuments {query, error in
            if error != nil {
                return
            }
            self.bucketItems = query?.documents.compactMap {
                let fbBucket = try? $0.data(as: FBBucketItem.self)
                guard let bucket = fbBucket else {
                    return nil
                }
                return self.convertFBBucketListToBucketList(bucketItem: bucket)
            } ?? []
        }
    }

    func addBucketItem(bucketItem: BucketItem) throws {
        _ = try store.collection(path).addDocument(from: bucketItem)
        bucketItems.append(bucketItem)
    }

    func updateBucketItem(bucketItem: BucketItem) throws {
        let fbLocation = convertBucketItemToFBBucketItem(bucketItem: bucketItem)
        let locationId = bucketItem.id
        try store.collection(path).document(locationId).setData(from: fbLocation)
        bucketItems.removeAll { $0.id == bucketItem.id }
        bucketItems.append(bucketItem)
    }

    func removeBucketItem(bucketItem: BucketItem) {
        let locationId = bucketItem.id
        store.collection(path).document(locationId).delete()
        bucketItems.removeAll { $0.id == bucketItem.id }
    }

    private func convertBucketItemToFBBucketItem(bucketItem: BucketItem) -> FBBucketItem {
        FBBucketItem(id: bucketItem.id,
                     locationName: bucketItem.locationName,
                     locationImage: bucketItem.locationImage,
                     userId: bucketItem.userId,
                     locationId: bucketItem.locationId,
                     dateVisited: bucketItem.dateVisited,
                     dateAdded: bucketItem.dateAdded)
    }

    private func convertFBBucketListToBucketList(bucketItem: FBBucketItem) -> BucketItem {
        guard let id = bucketItem.id else {
            fatalError("bucket id should be available")
        }
        return BucketItem(id: id,
                          locationName: bucketItem.locationName,
                          locationImage: bucketItem.locationImage,
                          userId: bucketItem.userId,
                          locationId: bucketItem.locationId,
                          dateVisited: bucketItem.dateVisited,
                          dateAdded: bucketItem.dateAdded)
    }
}
