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
    private var bucketModel: BucketModel<FBStorage<FBBucketItem>>
    private var locationModel: LocationModel<FBStorage<FBLocation>>
    private var bucketItems: [BucketItem] = []
    private var locations: [Location] = []
    private var cancellables: Set<AnyCancellable> = []
    private var nearbyBucketItem: BucketItem?
    private var arrivalTimeAtBucketItem: Date?
    private var levelSystemService: LevelSystemService?
    private let minimumVisitDuration = 300.0
    private let tempBucketItemKey = "tempBucketItem"
    private let tempDateKey = "tempDate"
    @Binding private var showLocationAlert: Bool
    @Binding private var alertTitle: String
    @Binding private var alertContent: String

    init(locationCoordinator: LocationCoordinator, locationModel: LocationModel<FBStorage<FBLocation>>,
         bucketModel: BucketModel<FBStorage<FBBucketItem>>, showLocationAlert: Binding<Bool>,
         alertTitle: Binding<String>, alertContent: Binding<String>, levelSystemService: LevelSystemService?) {
        self.locationModel = locationModel
        self.bucketModel = bucketModel
        self.locationCoordinator = locationCoordinator
        self.levelSystemService = levelSystemService
        self._showLocationAlert = showLocationAlert
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
            return
        }
        bucketItem.dateVisited = arrivalTime
        do {
            try bucketModel.updateBucketItem(bucketItem: bucketItem)
            levelSystemService?.generateExperienceFromFinishingBucketItem(bucketItem: bucketItem)
        } catch {
            print("Error: Failed to update storage")
            return
        }

        notifyUser(for: bucketItem)
    }

    private func isNearby(bucketItem: BucketItem, from point: CLLocationCoordinate2D) -> Bool {
        distance(from: bucketItem, to: point) < 500
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
        let body = "bucketlist updated"
        switch state {
        case .background:
            sendNotification(title: title, body: body)
        default:
            sendAlert(title: title, body: body)
        }
    }

    private func sendNotification(title: String, body: String) {
        let center = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default

        let uuidString = UUID().uuidString
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)
        center.add(request, withCompletionHandler: nil)
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