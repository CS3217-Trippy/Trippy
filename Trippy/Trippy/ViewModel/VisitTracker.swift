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
    private var visitModel: VisitModel<FBStorage<FBVisit>>
    private var bucketItems: [BucketItem] = []
    private var locations: [Location] = []
    private var visits: [Visit] = []
    private var userId: String
    private var cancellables: Set<AnyCancellable> = []
    private var levelSystemService: LevelSystemService?
    private var referenceLocation: CLLocation?
    @Binding private var showLocationAlert: Bool
    @Binding private var completedLocation: String
    @Binding private var alertTitle: String
    @Binding private var alertContent: String

    // Defaults
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
        guard let userId = bucketModel.userId else {
            fatalError("There should be a userid after login")
        }
        self.userId = userId
        self.visitModel = VisitModel(storage: FBStorage<FBVisit>(), userId: userId)
        self.visitModel.$visits.assign(to: \.visits, on: self)
            .store(in: &cancellables)
        self.locationModel.$locations.assign(to: \.locations, on: self)
            .store(in: &cancellables)
        self.bucketModel.$bucketItems.assign(to: \.bucketItems, on: self)
            .store(in: &cancellables)
        self.bucketModel.$bucketItems.sink { _ in self.establishGeofences() }
            .store(in: &cancellables)
        self.locationCoordinator.$currentLocation.sink { self.didUpdateLocations(location: $0) }
            .store(in: &cancellables)
        self.locationCoordinator.$enteredRegion.sink { self.trackVisit(for: $0?.identifier) }
            .store(in: &cancellables)
        self.locationCoordinator.$exitedRegion.sink { self.recordVisit(for: $0?.identifier) }
            .store(in: &cancellables)
    }

    func didUpdateLocations(location: CLLocationCoordinate2D?) {
        guard let location = location else {
            return
        }
        let currentLocation = CLLocation(latitude: location.latitude, longitude: location.longitude)
        if referenceLocation == nil {
            referenceLocation = currentLocation
        }
        guard let reference = referenceLocation else {
            return
        }

        // If user has moved past a certain threshold, recalculate the regions
        if currentLocation.distance(from: reference) > maxDistanceThreshhold {
            establishGeofences()
        }
    }

    func establishGeofences() {
        guard let currentLocation = locationCoordinator.currentLocation else {
            return
        }
        referenceLocation = CLLocation(latitude: currentLocation.latitude, longitude: currentLocation.longitude)
        locationCoordinator.clearMonitoredRegions()
        let selectedBucketItems: ArraySlice<BucketItem>

        // max allowed regions is 20, hence pick the closest 20 and less bucketitems.
        if bucketItems.count > 20 {
            selectedBucketItems = bucketItems
                .filter({ $0.dateVisited == nil })
                .sorted(by: { distance(from: $0, to: currentLocation) < distance(from: $1, to: currentLocation) })
                .prefix(20)
        } else {
            selectedBucketItems = bucketItems.prefix(bucketItems.count)
        }

        for bucketItem in selectedBucketItems {
            guard let center = locations.first(where: { $0.id == bucketItem.locationId })?.coordinates,
                  let id = bucketItem.id else {
                continue
            }
            locationCoordinator.monitorRegionAtLocation(center: center, radius: maxDistanceThreshhold, id: id)
            if isNearby(bucketItem: bucketItem, from: currentLocation) {
                trackVisit(for: id)
            }
        }
    }

    func trackVisit(for bucketItemId: String?) {
        guard let id = bucketItemId else {
            return
        }
        guard !visits.contains(where: { $0.bucketItemId == id }) else {
            return
        }
        let visit = Visit(id: nil, bucketItemId: id, userId: userId, arrivalTime: Date())
        do {
            try visitModel.add(visit)
        } catch {
            return
        }
    }

    private func recordVisit(for bucketItemId: String?) {
        guard let id = bucketItemId else {
            return
        }
        guard let visit = visits.first(where: { $0.bucketItemId == id }),
              let bucketItem = bucketItems.first(where: { $0.id == id }) else {
            return
        }
        let currentDate = Date()
        guard currentDate.timeIntervalSince(visit.arrivalTime) > minimumVisitDuration else {
            print("Visit was too short to be counted")
            visitModel.remove(visit)
            return
        }
        locationCoordinator.stopMonitoring(for: id)
        bucketItem.dateVisited = visit.arrivalTime
        do {
            print("bucketitem visited")
            try bucketModel.updateBucketItem(bucketItem: bucketItem)
            levelSystemService?.generateExperienceFromFinishingBucketItem(bucketItem: bucketItem)
        } catch {
            print("Error: Failed to update storage")
            return
        }
        removeOutdatedVisits()
        notifyUser(for: bucketItem)
    }

    func removeOutdatedVisits() {
        for visit in visits {
            if !locationCoordinator.monitoredRegions
                .contains(where: { $0.identifier == visit.bucketItemId }) {
                visitModel.remove(visit)
            }
        }
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
 }
