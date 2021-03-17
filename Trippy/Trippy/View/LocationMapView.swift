//
//  LocationMapView.swift
//  Trippy
//
//  Created by QL on 10/3/21.
//

import SwiftUI
import MapKit
import CoreLocation

struct LocationMapView: View {
    @State private var map = MKMapView()
    @State private var locationManager = CLLocationManager()
    @State private var showLocationAlert = false
    @State private var showDetailView = false
    @State private var selectedLocation: Location? = nil
    @ObservedObject var viewModel: LocationMapViewModel
    
    var body: some View {
        VStack {
            DisplayLocationsMapView(
                map: self.$map,
                locationManager: self.$locationManager,
                showLocationAlert: self.$showLocationAlert,
                showDetailView: self.$showDetailView,
                selectedLocation: self.$selectedLocation,
                viewModel: viewModel
            )
            .onAppear {
                self.locationManager.requestAlwaysAuthorization()
            }
            
            if let selectedLocation = selectedLocation {
                NavigationLink(
                    destination: LocationDetailView(viewModel: .init(location: selectedLocation)),
                    isActive: $showDetailView
                ) { EmptyView() }
            }
        }
        .edgesIgnoringSafeArea(.all)
        .alert(isPresented: $showLocationAlert) {
            Alert(
                title: Text("Unable to retrieve current location"),
                message: Text("Please check that you have enabled the location permissions."))
        }
    }
}

struct MapInterfaceView_Previews: PreviewProvider {
    static var previews: some View {
        let model = LocationModel(storage: PreviewLocationStorage())
        LocationMapView(viewModel: .init(locationModel: model))
    }
}
