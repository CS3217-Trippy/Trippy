//
//  AddLocationView.swift
//  Trippy
//
//  Created by QL on 17/3/21.
//

import SwiftUI
import CoreLocation
import MapKit

struct AddLocationView: View {
    @State private var map = MKMapView()
    @State private var locationManager = CLLocationManager()
    @State private var showLocationAlert = false
    @State private var locationName: String = ""
    @State private var locationDescription: String = ""
    let viewModel = AddLocationViewModel()
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        Form {
            Section {
                TextField("Name of Location", text: $locationName)
                TextField("Description of Location", text: $locationDescription)
            }
            
            Section {
                AddLocationMapView(map: $map, locationManager: $locationManager, showLocationAlert: $showLocationAlert)
                .onAppear {
                    self.locationManager.requestAlwaysAuthorization()
                }
                .alert(isPresented: $showLocationAlert) {
                    Alert(
                        title: Text("Unable to retrieve current location"),
                        message: Text("Please check that you have enabled the location permissions."))
                }
            }
            .aspectRatio(contentMode: .fill)
            
            Section {
                Button("Submit") {
                    guard let coordinate = map.annotations.first?.coordinate else {
                        return
                    }
                    viewModel.saveForm(name: locationName, description: locationDescription, coordinates: coordinate)
                    presentationMode.wrappedValue.dismiss()
                }
            }
            .disabled(map.annotations.isEmpty || !viewModel.isValidName(name: locationName) || !viewModel.isValidDescription(description: locationDescription))
        }.navigationBarTitle("Submit new location")
    }
}

struct AddLocationView_Previews: PreviewProvider {
    static var previews: some View {
        AddLocationView()
    }
}
