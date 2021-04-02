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
        List {
            if !viewModel.recommendedLocationViewModels.isEmpty {
                VStack(alignment: .leading) {
                    Text("Recommended").font(.title2).fontWeight(.bold).foregroundColor(.green)
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(viewModel.recommendedLocationViewModels, id: \.id) { locationCardViewModel in
                                LocationCardView(viewModel: locationCardViewModel,
                                                 showFullDetails: false,
                                                 isHorizontal: false)
                            }
                        }
                    }.frame(height: 200)
                }
            }
            ForEach(viewModel.locationCardViewModels, id: \.id) { locationCardViewModel in
                LocationCardView(viewModel: locationCardViewModel,
                                 showFullDetails: true,
                                 isHorizontal: true).frame(height: 200)
            }
        }.navigationBarTitle(viewTitle)
        .padding(.horizontal)
        .onAppear(perform: viewModel.fetchRecommendedLocations)
    }
}
