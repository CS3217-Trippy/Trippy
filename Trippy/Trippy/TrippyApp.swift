//
//  TrippyApp.swift
//  Trippy
//
//  Created by Lim Chun Yong on 9/3/21.
//

import SwiftUI
import Firebase

@main
struct TrippyApp: App {
    let locationStorage: LocationStorage
    let locationModel: LocationModel
    let locationListViewModel: LocationListViewModel
    init() {
        FirebaseApp.configure()
        locationStorage = FBLocationStorage()
        locationModel = LocationModel(storage: locationStorage)
        locationListViewModel = LocationListViewModel(locationModel: locationModel)
    }
    
    var body: some Scene {
        WindowGroup {
            LocationListView(viewModel: locationListViewModel)
        }
    }
}
