//
//  AddLocationMapView.swift
//  Trippy
//
//  Created by QL on 16/3/21.
//

import SwiftUI
import MapKit
import CoreLocation

struct AddLocationMapView: UIViewRepresentable {
    @Binding var map: MKMapView
    @Binding var showLocationAlert: Bool
    @Binding var selectedLocation: CLLocationCoordinate2D
    @EnvironmentObject var locationCoordinator: LocationCoordinator

    func makeUIView(context: Context) -> MKMapView {
        map.delegate = context.coordinator
        map.showsUserLocation = true
        let tapWithinMap = UITapGestureRecognizer(
            target: context.coordinator, action: #selector(context.coordinator.addPin(sender:)))
        map.addGestureRecognizer(tapWithinMap)
        return map
    }

    func updateUIView(_ uiView: UIViewType, context: Context) {
        // Do nothing
    }

    func makeCoordinator() -> AddLocationMapCoordinator {
        AddLocationMapCoordinator(parent: self)
    }
}
