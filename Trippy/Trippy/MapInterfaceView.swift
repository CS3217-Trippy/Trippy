//
//  MapView.swift
//  Trippy
//
//  Created by QL on 10/3/21.
//

import SwiftUI
import MapKit
import CoreLocation

struct MapInterfaceView: View {
    @State var map = MKMapView()
    @State var locationManager = CLLocationManager()
    @State var showLocationAlert = false
    
    var body: some View {
        ZStack {
            VStack {
                MapView(map: self.$map, locationManager: self.$locationManager, showLocationAlert: self.$showLocationAlert)
                .onAppear {
                    self.locationManager.requestAlwaysAuthorization()
                }
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct MapInterfaceView_Previews: PreviewProvider {
    static var previews: some View {
        MapInterfaceView()
    }
}

struct MapView: UIViewRepresentable {
    @Binding var map: MKMapView
    @Binding var locationManager: CLLocationManager
    @Binding var showLocationAlert: Bool
    
    func makeUIView(context: Context) -> MKMapView {
        map.delegate = context.coordinator
        locationManager.delegate = context.coordinator
        map.showsUserLocation = true
        return map
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        // Do nothing
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    class Coordinator: NSObject, MKMapViewDelegate, CLLocationManagerDelegate {
        var parent: MapView
        
        init(parent: MapView) {
            self.parent = parent
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
    }
}


