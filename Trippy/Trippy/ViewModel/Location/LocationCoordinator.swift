//
//  LocationCoordinator.swift
//  Trippy
//
//  Created by QL on 30/3/21.
//

import CoreLocation
import Combine

class LocationCoordinator: NSObject, CLLocationManagerDelegate, ObservableObject {
    private let locationManager = CLLocationManager()
    @Published var currentLocation: CLLocationCoordinate2D?
    @Published var enteredRegion: CLRegion?
    @Published var exitedRegion: CLRegion?
    @Published var authorizationStatus: CLAuthorizationStatus = .denied
    private let approximateDistanceFilter = 500.0
    private let accurateDistanceFilter = 10.0

    override init() {
        super.init()
        locationManager.delegate = self
        self.locationManager.requestAlwaysAuthorization()
        authorizationStatus = locationManager.authorizationStatus
        locationManager.allowsBackgroundLocationUpdates = true
        enableAccurateLocation()
    }

    var monitoredRegions: Set<CLRegion> {
        locationManager.monitoredRegions
    }

    func clearMonitoredRegions() {
        let monitoredRegions = locationManager.monitoredRegions
        for region in monitoredRegions {
            locationManager.stopMonitoring(for: region)
        }
    }

    func enableAccurateLocation() {
        locationManager.distanceFilter = accurateDistanceFilter
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.startUpdatingLocation()
    }

    func enableApproximateLocation() {
        locationManager.distanceFilter = approximateDistanceFilter
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.startUpdatingLocation()
        locationManager.pausesLocationUpdatesAutomatically = false
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            enableAccurateLocation()
        }
        authorizationStatus = locationManager.authorizationStatus
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations.last?.coordinate
    }

    func monitorRegionAtLocation(center: CLLocationCoordinate2D, radius: Double, id: String ) {
        if CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self) {
            let region = CLCircularRegion(center: center,
                                          radius: radius, identifier: id)
            region.notifyOnEntry = true
            region.notifyOnExit = true

            locationManager.startMonitoring(for: region)
        }
    }

    func stopMonitoring(for regionId: String) {
        guard let region = monitoredRegions.first(where: { $0.identifier == regionId }) else {
            return
        }
        locationManager.stopMonitoring(for: region)
    }

    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        enteredRegion = region
    }

    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        exitedRegion = region
    }
}
