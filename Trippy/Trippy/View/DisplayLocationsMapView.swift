//
//  DisplayLocationsMapView.swift
//  Trippy
//
//  Created by QL on 16/3/21.
//

import SwiftUI
import MapKit
import CoreLocation

struct DisplayLocationsMapView: UIViewRepresentable {
    @Binding var map: MKMapView
    @Binding var showLocationAlert: Bool
    @Binding var showDetailView: Bool
    @Binding var selectedLocation: Location?
    @ObservedObject var viewModel: LocationMapViewModel
    @EnvironmentObject var locationCoordinator: LocationCoordinator

    func makeUIView(context: Context) -> MKMapView {
        map.delegate = context.coordinator
        map.showsUserLocation = true
        return map
    }

    func updateUIView(_ uiView: UIViewType, context: Context) {
        // Do nothing
    }

    func makeCoordinator() -> DisplayLocationsMapCoordinator {
        DisplayLocationsMapCoordinator(parent: self)
    }
}
