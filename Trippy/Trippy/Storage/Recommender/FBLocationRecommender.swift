import Combine
import FirebaseFirestore
import FirebaseFirestoreSwift
import Firebase

class FBLocationRecommender: LocationRecommender {

    var recommendedItems: Published<[Location]>.Publisher {
        $_recommendedItems
    }
    @Published private var _recommendedItems: [Location] = []
    private var store = Firestore.firestore()
    private let path = "locations"
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
        let bucketListPath = "bucketItems"
        let field = "userId"
        store.collection(bucketListPath).whereField(field, isEqualTo: userId).getDocuments { snapshot, error in
            if error != nil {
                return
            }
            self.currentLocationsInBucketList = self.getLocationIdsFromBucketListSnapshot(snapshot: snapshot)
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
        let bucketListPath = "bucketItems"
        let field = "userId"
        store.collection(bucketListPath).whereField(field, isEqualTo: userId).getDocuments { snapshot, error in
            if error != nil {
                return
            }
            let categories = self.getCategoriesFromBucketListSnapshot(snapshot: snapshot)
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
        let bucketListPath = "bucketItems"
        let userIdField = "userId"
        let locationField = "locationId"
        store.collection(bucketListPath)
            .whereField(locationField, in: currentLocationsInBucketList)
            .whereField(userIdField, isNotEqualTo: userId).getDocuments {snapshot, _ in
                let userIds = self.getUniqueUserIdsFromSnapshot(snapshot: snapshot)
                self.getUserRecommendationsFromUserIds(userIds: userIds)
            }
    }

    /**
     Given an array of user ids, get the locations that they like that are not currently liked by the current user
     */
    private func getUserRecommendationsFromUserIds(userIds: Set<String>) {
        for userId in userIds {
            let bucketListPath = "bucketItems"
            let userIdField = "userId"
            let locationIdField = "locationId"
            store.collection(bucketListPath).whereField(
                locationIdField,
                notIn: currentLocationsInBucketList)
                .whereField(userIdField, isEqualTo: userId).getDocuments { snapshot, _ in
                    let locationIdsOfUserRecommendations = self.getLocationIdsFromBucketListSnapshot(snapshot: snapshot)
                    self.getLocationsFromLocationIds(locationIds: locationIdsOfUserRecommendations)
                }
        }
    }
    /**
     Given an array of location ids, gets the location data for each location
     */
    private func getLocationsFromLocationIds(locationIds: [String]) {
        for locationId in locationIds {
            store.collection(path).document(locationId).getDocument { snapshot, error in
                if error != nil {
                    return
                }
                guard let location = try? snapshot?.data(as: FBLocation.self) else {
                    return
                }
                self.addLocationToRecommended(location: location.convertToModelType())
            }
        }
    }

    /**
     Gets the unique set of user ids from a QuerySnapshot
     */
    private func getUniqueUserIdsFromSnapshot(snapshot: QuerySnapshot?) -> Set<String> {
        let users: [String] = snapshot?.documents.compactMap {
            guard let fbItem = try? $0.data(as: FBBucketItem.self) else {
                return nil
            }
            return fbItem.userId
        } ?? []
        return Set(users)
    }

    /**
     Gets the location ids from a QuerySnapshot of bucket items
     */
    private func getLocationIdsFromBucketListSnapshot(snapshot: QuerySnapshot?) -> [String] {
        let bucketItems: [FBBucketItem] = snapshot?.documents.compactMap {
            guard let fbItem = try? $0.data(as: FBBucketItem.self) else {
                return nil
            }
            return fbItem
        } ?? []
        return bucketItems.map { $0.locationId }
    }

    /**
     Given a QuerySnapshot, gets the unique categories of these bucket items
     */
    private func getCategoriesFromBucketListSnapshot(snapshot: QuerySnapshot?) -> Set<String> {
        let bucketItems: [FBBucketItem] = snapshot?.documents.compactMap {
            guard let fbItem = try? $0.data(as: FBBucketItem.self) else {
                return nil
            }
            return fbItem
        } ?? []
        return Set(bucketItems.map { $0.locationCategory.rawValue })
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
        store.collection(path).whereField(field, in: arr).getDocuments { snapshot, error in
            if error != nil {
                return
            }
            let locations = self.getLocationsFromSnapshot(snapshot: snapshot)
            self.addLocationArray(locations: locations)
        }
    }

    /**
     Given a QuerySnapshot, returns an array of `Location`
     */
    private func getLocationsFromSnapshot(snapshot: QuerySnapshot?) -> [Location] {
        let locations: [Location] = snapshot?.documents.compactMap {
            guard let fbItem = try? $0.data(as: FBLocation.self) else {
                return nil
            }
            return fbItem.convertToModelType()
        } ?? []
        return locations
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
