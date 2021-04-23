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
    @State private var showLocationAlert = false
    @State private var showDetailView = false
    @State private var selectedLocation: Location?
    @ObservedObject var viewModel: LocationMapViewModel

    var body: some View {
        VStack {
            DisplayLocationsMapView(
                map: self.$map,
                showLocationAlert: self.$showLocationAlert,
                showDetailView: self.$showDetailView,
                selectedLocation: self.$selectedLocation,
                viewModel: viewModel
            )

            if let selectedLocation = selectedLocation {
                NavigationLink(
                    destination: LocationDetailView(viewModel: .init(location: selectedLocation,
                                                                     imageModel: viewModel.imageModel,
                                                                     ratingModel: viewModel.ratingModel,
                                                                     bucketModel: viewModel.bucketModel,
                                                                     meetupModel: viewModel.meetupModel,
                                                                     userId: viewModel.userId)),
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
