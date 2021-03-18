import Combine

protocol BucketListStorage {
    func fetchBucketItems()

    func addBucketItem(bucketItem: BucketItem) throws

    func updateBucketItem(bucketItem: BucketItem) throws

    func removeBucketItem(bucketItem: BucketItem)

    var bucketList: Published<[BucketItem]>.Publisher { get }
}
