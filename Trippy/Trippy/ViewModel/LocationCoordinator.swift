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
    @Published var authorizationStatus: CLAuthorizationStatus = .denied
    @Published var visited: CLVisit?

    override init() {
        super.init()
        locationManager.delegate = self
        self.locationManager.requestAlwaysAuthorization()
        authorizationStatus = locationManager.authorizationStatus
        locationManager.allowsBackgroundLocationUpdates = true
        enableAccurateLocation()
    }

    func enableAccurateLocation() {
        locationManager.stopMonitoringSignificantLocationChanges()
        locationManager.startUpdatingLocation()
    }

    func enableApproximateLocation() {
        locationManager.stopUpdatingLocation()
        locationManager.startMonitoringSignificantLocationChanges()
        locationManager.pausesLocationUpdatesAutomatically = false
        print("Monitoring in background")
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            enableAccurateLocation()
        }
        authorizationStatus = locationManager.authorizationStatus
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations.last?.coordinate
        print("location updated to: \(currentLocation?.latitude ?? 0.0),\(currentLocation?.longitude ?? 0.0)")
    }
}
