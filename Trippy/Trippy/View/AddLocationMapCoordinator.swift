//
//  AddLocationMapCoordinator.swift
//  Trippy
//
//  Created by QL on 16/3/21.
//

import MapKit
import Combine
import SwiftUI

class AddLocationMapCoordinator: NSObject, MKMapViewDelegate, CLLocationManagerDelegate {
    var parent: AddLocationMapView
    private var cancellables: Set<AnyCancellable> = []

    init(parent: AddLocationMapView) {
        self.parent = parent
        super.init()
        self.parent.map.removeAnnotations(self.parent.map.annotations)
        self.parent.locationCoordinator.$currentLocation.sink {
            self.willUpdateLocation(newLocation: $0)
        }.store(in: &cancellables)
        self.parent.locationCoordinator.$authorizationStatus.sink {
            self.willChangeAuthorization(status: $0)
        }.store(in: &cancellables)
    }

    func willChangeAuthorization(status: CLAuthorizationStatus) {
        if status == .denied {
            self.parent.showLocationAlert.toggle()
        }
    }

    func willUpdateLocation(newLocation: CLLocationCoordinate2D? ) {
        guard let location = newLocation else {
            return
        }
        self.parent.map.setCenter(location, animated: true)
    }

    func mapView(
        _ mapView: MKMapView,
        viewFor annotation: MKAnnotation
      ) -> MKAnnotationView? {
        guard let annotation = annotation as? LocationPin else {
          return nil
        }
        let identifier = "newLocation"
        var view: MKMarkerAnnotationView
        if let dequeuedView = mapView.dequeueReusableAnnotationView(
          withIdentifier: identifier) as? MKMarkerAnnotationView {
          dequeuedView.annotation = annotation
          view = dequeuedView
        } else {
          view = MKMarkerAnnotationView(
            annotation: annotation,
            reuseIdentifier: identifier)
          view.canShowCallout = false
        }
        return view
      }

    @objc func addPin(sender: UITapGestureRecognizer) {
        let location = sender.location(in: parent.map)
        let coordinate = parent.map.convert(location, toCoordinateFrom:
             parent.map)
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = "Selected"
        parent.selectedLocation = coordinate
        parent.map.removeAnnotations(parent.map.annotations)
        parent.map.addAnnotation(annotation)
    }
}
