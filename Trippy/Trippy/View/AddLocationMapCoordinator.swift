//
//  AddLocationMapCoordinator.swift
//  Trippy
//
//  Created by QL on 16/3/21.
//

import MapKit

class AddLocationMapCoordinator: NSObject, MKMapViewDelegate, CLLocationManagerDelegate {
    var parent: AddLocationMapView
    
    init(parent: AddLocationMapView) {
        self.parent = parent
        super.init()
        self.parent.map.removeAnnotations(self.parent.map.annotations)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .denied{
            self.parent.showLocationAlert.toggle()
        }
        else{
            self.parent.locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocation = locations.last?.coordinate else {
            return
        }
        self.parent.map.setCenter(currentLocation, animated: true)
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
        parent.map.removeAnnotations(parent.map.annotations)
        parent.map.addAnnotation(annotation)
    }
}
