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
    @State private var showStorageError = false
    let viewModel: AddLocationViewModel
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
                .padding()
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
                    do {
                        try viewModel.saveForm(name: locationName, description: locationDescription, coordinates: coordinate)
                    } catch {
                        showStorageError = true
                    }
                    presentationMode.wrappedValue.dismiss()
                }
                .alert(isPresented: $showStorageError) {
                    Alert(
                        title: Text("An error occurred while attempting to save the information.")
                    )
                }
            }
            .disabled(map.annotations.isEmpty || !viewModel.isValidName(name: locationName) || !viewModel.isValidDescription(description: locationDescription))
        }.navigationBarTitle("Submit new location")
    }
}

struct AddLocationView_Previews: PreviewProvider {
    static var previews: some View {
        let locationModel = LocationModel(storage: PreviewLocationStorage())
        AddLocationView(viewModel: .init(locationModel: locationModel))
    }
}
