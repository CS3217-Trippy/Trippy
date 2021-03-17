//
//  LocationListView.swift
//  Trippy
//
//  Created by QL on 13/3/21.
//

import SwiftUI

struct LocationListView: View {
    @ObservedObject var viewModel: LocationListViewModel
    let viewTitle = "Locations"
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                HStack {
                    NavigationLink(
                        destination: LocationMapView(viewModel: .init(locationModel: viewModel.locationModel))) {
                        Text("Map")
                    }
                    Spacer()
                    NavigationLink(
                        destination: AddLocationView(viewModel: .init(locationModel: viewModel.locationModel))) {
                        Text("Submit new location")
                    }
                }
                .padding()
                CollectionView(data:$viewModel.locationCardViewModels ,cols: 2, spacing: 20) {
                    locationCardViewModel in
                        LocationCardView(viewModel: locationCardViewModel)
                        
                }
                .padding(.horizontal)
            }
            .navigationBarTitle(viewTitle)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct LocationListView_Previews: PreviewProvider {
    static var previews: some View {
        let previewModel = LocationModel(storage: PreviewLocationStorage())
        let locationListViewModel = LocationListViewModel(locationModel: previewModel)
        return LocationListView(viewModel: locationListViewModel)
    }
}
