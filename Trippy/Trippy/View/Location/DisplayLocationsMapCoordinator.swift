//
//  Coordinator.swift
//  Trippy
//
//  Created by QL on 16/3/21.
//

import MapKit
import Combine
import SwiftUI

class DisplayLocationsMapCoordinator: NSObject, MKMapViewDelegate {
    var parent: DisplayLocationsMapView
    var locationPins: [LocationPin] = []
    private var cancellables: Set<AnyCancellable> = []

    init(parent: DisplayLocationsMapView) {
        self.parent = parent
        super.init()
        loadPins()
        self.parent.map.removeAnnotations(self.parent.map.annotations)
        self.parent.map.addAnnotations(locationPins)
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
        let identifier = "location"
        var view: MKMarkerAnnotationView
        if let dequeuedView = mapView.dequeueReusableAnnotationView(
          withIdentifier: identifier) as? MKMarkerAnnotationView {
          dequeuedView.annotation = annotation
          view = dequeuedView
        } else {
          view = MKMarkerAnnotationView(
            annotation: annotation,
            reuseIdentifier: identifier)
          view.canShowCallout = true
          view.calloutOffset = CGPoint(x: -5, y: 5)
          view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        return view
      }

    func mapView(
      _ mapView: MKMapView,
      annotationView view: MKAnnotationView,
      calloutAccessoryControlTapped control: UIControl
    ) {
      guard let locationPin = view.annotation as? LocationPin else {
        return
      }
        parent.selectedLocation = locationPin.location
        parent.showDetailView.toggle()
    }

    private func loadPins() {
        parent.viewModel.locations.forEach { locationPins.append(.init(location: $0)) }
    }
}
