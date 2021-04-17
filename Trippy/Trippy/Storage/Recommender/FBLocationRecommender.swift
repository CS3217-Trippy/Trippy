import Combine
import FirebaseFirestore
import FirebaseFirestoreSwift
import Firebase

class FBLocationRecommender: LocationRecommender {

    var recommendedItems: Published<[Location]>.Publisher {
        $_recommendedItems
    }
    @Published private var _recommendedItems: [Location] = []
    private var bucketItemStore: FBStorage<FBBucketItem> = FBStorage<FBBucketItem>()
    private var locationItemStore: FBStorage<FBLocation> = FBStorage<FBLocation>()
    private let userId: String?
    private var currentLocationsInBucketList: [String] = []

    init(userId: String?) {
        self.userId = userId
        fetch()
    }

    func fetch() {
        guard let userId = userId else {
            return
        }
        let field = "userId"
        bucketItemStore.fetchWithField(field: field, value: userId) { bucketItems in
            self.currentLocationsInBucketList = self.getLocationIdsFromBucketList(bucketItems: bucketItems)
            self.getContentRecommendations()
            self.getCollaborativeRecommendations()
        }
    }

    /**
     Gets locations similar to those in the user's bucketlist
     */
    private func getContentRecommendations() {
        guard let userId = userId else {
            return
        }
        guard !currentLocationsInBucketList.isEmpty else {
            return
        }
        let field = "userId"
        bucketItemStore.fetchWithField(field: field, value: userId) { bucketItems in
            let categories = self.getCategoriesFromBucketList(bucketItems: bucketItems)
            self.getLocationsWithSameCategory(categories: categories)
        }
    }

    /**
     Gets locations from the bucketlist of other users who have similar bucketlists as current user
     */
    private func getCollaborativeRecommendations() {
        guard let userId = userId else {
            return
        }
        guard !currentLocationsInBucketList.isEmpty else {
            return
        }
        let locationField = "locationId"
        bucketItemStore.fetchWithFieldContainsAny(field: locationField,
                                                  value: currentLocationsInBucketList) { bucketItems in
            let filteredBucketItems = self.getBucketItemsNotBelongingToUser(userId: userId, bucketItems: bucketItems)
            let userIds = self.getUniqueUserIdsFromBucketList(bucketItems: filteredBucketItems)
            self.getUserRecommendationsFromUserIds(userIds: userIds)
        }
    }

    private func getBucketItemsNotBelongingToUser(userId: String, bucketItems: [BucketItem]) -> [BucketItem] {
        bucketItems.filter { $0.userId != userId }
    }

    /**
     Given an array of user ids, get the locations that they like that are not currently liked by the current user
     */
    private func getUserRecommendationsFromUserIds(userIds: Set<String>) {
        for userId in userIds {
            let field = "userId"
            bucketItemStore.fetchWithField(field: field, value: userId) { bucketItems in
                let filteredBucketItems = self.getBucketItemsNotInCurrentList(bucketItems: bucketItems)
                let locationIdsOfUserRecommendations = self.getLocationIdsFromBucketList(
                    bucketItems: filteredBucketItems)
                self.getLocationsFromLocationIds(locationIds: locationIdsOfUserRecommendations)
            }
        }
    }

    private func getBucketItemsNotInCurrentList(bucketItems: [BucketItem]) -> [BucketItem] {
        bucketItems.filter { bucketItem in
           !self.currentLocationsInBucketList.contains(bucketItem.locationId)
        }
    }

    /**
     Given an array of location ids, gets the location data for each location
     */
    private func getLocationsFromLocationIds(locationIds: [String]) {
        for locationId in locationIds {
            locationItemStore.fetchWithId(id: locationId) {location in
                self.addLocationToRecommended(location: location)
            }
        }
    }

    /**
     Gets the unique set of user ids from array of bucket items
     */
    private func getUniqueUserIdsFromBucketList(bucketItems: [BucketItem]) -> Set<String> {
        let users: [String] = bucketItems.map { $0.userId }
        return Set(users)
    }

    /**
     Gets the location ids from an array of bucket items
     */
    private func getLocationIdsFromBucketList(bucketItems: [BucketItem]) -> [String] {
        bucketItems.map { $0.locationId }
    }

    /**
     Given an array of bucket items, gets the unique categories of these bucket items
     */
    private func getCategoriesFromBucketList(bucketItems: [BucketItem]) -> Set<String> {
        Set(bucketItems.map { $0.locationCategory.rawValue })
    }

    /**
     Given a Set of categories, gets the locations with similar categories
     */
    private func getLocationsWithSameCategory(categories: Set<String>) {
        let arr = Array(categories)
        guard !arr.isEmpty else {
            return
        }
        let field = "category"
        locationItemStore.fetchWithFieldContainsAny(field: field, value: arr) { locations in
            self.addLocationArray(locations: locations)
        }
    }

    /**
     Adds an array of `Location` to the recommended list
     */
    private func addLocationArray(locations: [Location]) {
        for location in locations {
            addLocationToRecommended(location: location)
        }
    }

    /**
     Adds a `Location` to the recommended list
     */
    private func addLocationToRecommended(location: Location) {
        guard let locationId = location.id else {
            return
        }
        let isExisting = _recommendedItems.contains(where: { $0.id == location.id })
            || currentLocationsInBucketList.contains(locationId)
        if !isExisting {
            _recommendedItems.insert(location, at: 0)
        }
    }

}
