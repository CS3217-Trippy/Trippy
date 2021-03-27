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
            CollectionView(data: $viewModel.locationCardViewModels, cols: 2, spacing: 20) { locationCardViewModel in
                    LocationCardView(viewModel: locationCardViewModel)
            }
            .padding(.horizontal)
        }
        .navigationBarTitle(viewTitle)
    }
}
