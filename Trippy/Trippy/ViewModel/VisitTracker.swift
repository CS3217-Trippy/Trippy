//
//  VisitTracker.swift
//  Trippy
//
//  Created by QL on 1/4/21.
//

import Combine
import CoreLocation
import SwiftUI
import UserNotifications

class VisitTracker {
    private let locationCoordinator: LocationCoordinator
    private let notificationManager: NotificationManager
    private var bucketModel: BucketModel<FBStorage<FBBucketItem>>
    private var ratingModel: RatingModel<FBStorage<FBRating>>
    private var locationModel: LocationModel<FBStorage<FBLocation>>
    private var bucketItems: [BucketItem] = []
    private var locations: [Location] = []
    private var cancellables: Set<AnyCancellable> = []
    private var nearbyBucketItem: BucketItem?
    private var arrivalTimeAtBucketItem: Date?
    private var levelSystemService: LevelSystemService?
    @Binding private var showLocationAlert: Bool
    @Binding private var completedLocation: String
    @Binding private var alertTitle: String
    @Binding private var alertContent: String
    private let tempBucketItemKey = "tempBucketItem"
    private let tempDateKey = "tempDate"
    private let minimumVisitDuration = 300.0
    private let maxDistanceThreshhold = 500.0
    private let notificationCategoryName = "rateAfterVisit"
    private let ratingActions = [
        UNNotificationAction(identifier: "rate1", title: "1"),
        UNNotificationAction(identifier: "rate2", title: "2"),
        UNNotificationAction(identifier: "rate3", title: "3"),
        UNNotificationAction(identifier: "rate4", title: "4"),
        UNNotificationAction(identifier: "rate5", title: "5")
    ]

    init(locationCoordinator: LocationCoordinator, notificationManager: NotificationManager,
         locationModel: LocationModel<FBStorage<FBLocation>>,
         bucketModel: BucketModel<FBStorage<FBBucketItem>>, showLocationAlert: Binding<Bool>,
         completedLocation: Binding<String>,
         alertTitle: Binding<String>, alertContent: Binding<String>, levelSystemService: LevelSystemService?,
         ratingModel: RatingModel<FBStorage<FBRating>>) {
        self.locationModel = locationModel
        self.bucketModel = bucketModel
        self.ratingModel = ratingModel
        self.locationCoordinator = locationCoordinator
        self.notificationManager = notificationManager
        self.levelSystemService = levelSystemService
        self._showLocationAlert = showLocationAlert
        self._completedLocation = completedLocation
        self._alertTitle = alertTitle
        self._alertContent = alertContent
        self.locationModel.$locations.assign(to: \.locations, on: self)
            .store(in: &cancellables)
        self.bucketModel.$bucketItems.assign(to: \.bucketItems, on: self)
            .store(in: &cancellables)
        self.locationCoordinator.$currentLocation.sink { location in
            guard let location = location else {
                return
            }
            self.trackBucketItemProximities(location: location)
        }.store(in: &cancellables)
        let nearbyBucketItemId = UserDefaults.standard.string(forKey: tempBucketItemKey)
        if let id = nearbyBucketItemId {
            nearbyBucketItem = bucketItems.first { $0.id == id }
        }
        arrivalTimeAtBucketItem = UserDefaults.standard.object(forKey: tempDateKey) as? Date
    }

    func trackBucketItemProximities(location: CLLocationCoordinate2D) {
        if let bucketItem = nearbyBucketItem {
            if !isNearby(bucketItem: bucketItem, from: location) {
                print("Left \(bucketItem.locationName)")
                recordVisitForBucketItem()
                nearbyBucketItem = nil
                arrivalTimeAtBucketItem = nil
                saveTempData()
            } else {
                return
            }
        }
        let nearestBucketItem = bucketItems.filter({ $0.dateVisited == nil }).min { itemX, itemY in
            distance(from: itemX, to: location) < distance(from: itemY, to: location)
        }
        guard let nearestItem = nearestBucketItem else {
            return
        }
        if isNearby(bucketItem: nearestItem, from: location) {
            print("\(nearestItem.locationName) is currently nearby")
            nearbyBucketItem = nearestItem
            arrivalTimeAtBucketItem = Date()
            saveTempData()
        }
    }

    private func recordVisitForBucketItem() {
        let currentDate = Date()
        guard let arrivalTime = arrivalTimeAtBucketItem, let bucketItem = nearbyBucketItem else {
            return
        }
        guard currentDate.timeIntervalSince(arrivalTime) > minimumVisitDuration else {
            print("Visit was too short to be counted")
            return
        }
        bucketItem.dateVisited = arrivalTime
        do {
            print("bucketitem visited")
            try bucketModel.updateBucketItem(bucketItem: bucketItem)
            levelSystemService?.generateExperienceFromFinishingBucketItem(bucketItem: bucketItem)
        } catch {
            print("Error: Failed to update storage")
            return
        }

        notifyUser(for: bucketItem)
    }

    private func isNearby(bucketItem: BucketItem, from point: CLLocationCoordinate2D) -> Bool {
        distance(from: bucketItem, to: point) < maxDistanceThreshhold
    }

    private func distance(from bucketItem: BucketItem, to point: CLLocationCoordinate2D) -> Double {
        let bucketItemCoordinates = getCoordinateOfBucketItem(bucketItem: bucketItem)
        return CLLocation(latitude: point.latitude, longitude: point.longitude)
            .distance(from: .init(latitude: bucketItemCoordinates.latitude, longitude: bucketItemCoordinates.longitude))
    }

    private func getCoordinateOfBucketItem(bucketItem: BucketItem) -> CLLocationCoordinate2D {
        guard let coordinates = locations.first(where: { bucketItem.locationId == $0.id })?.coordinates else {
            fatalError("Data Corruption Error: The coordinate for the bucket item is missing")
        }
        return coordinates
    }

    private func notifyUser(for bucketItem: BucketItem) {
        let state = UIApplication.shared.applicationState
        let title = "Congrats! You have visited \(bucketItem.locationName)"
        let alertBody = "Please leave a rating!"
        let notificationBody = "Tap and hold to leave a rating!"
        switch state {
        case .background:
            notificationManager.sendNotificationWithActions(
                title: title,
                body: notificationBody,
                categoryName: notificationCategoryName,
                actions: ratingActions
            ) { actionId in
                self.rate(actionId: actionId, locationId: bucketItem.locationId)
            }
        default:
            completedLocation = bucketItem.locationId
            sendAlert(title: title, body: alertBody)
        }
    }

    private func rate(actionId: String, locationId: String) {
        guard let choiceOfRating = ratingActions.first(where: { $0.identifier == actionId }) else {
            print("ERROR: Invalid choice")
            return
        }
        guard let score = Int(choiceOfRating.title) else {
            print("ERROR: Invalid score")
            return
        }
        guard let userId = bucketModel.userId else {
            print("ERROR: Invalid user")
            return
        }
        let rating = Rating(id: nil, locationId: locationId, userId: userId, score: score, date: Date())
        do {
            try ratingModel.add(rating: rating)
        } catch {
            print("ERROR: Unable to save. \(error.localizedDescription)")
        }
    }

    private func sendAlert(title: String, body: String) {
        alertTitle = title
        alertContent = body
        showLocationAlert = true
    }

    private func saveTempData() {
        UserDefaults.standard.setValue(nearbyBucketItem?.id, forKey: tempBucketItemKey)
        UserDefaults.standard.setValue(arrivalTimeAtBucketItem, forKey: tempDateKey)
    }
 }
