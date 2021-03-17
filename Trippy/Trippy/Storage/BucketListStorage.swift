import Combine

protocol BucketListStorage {
    var bucketList: Published<[BucketItem]>.Publisher { get }
    
    func fetchBucketItems()
    
    func addBucketItem(bucketItem: BucketItem) throws
    
    func updateBucketItem(bucketItem: BucketItem) throws
    
    func removeBucketItem(bucketItem: BucketItem)
}
