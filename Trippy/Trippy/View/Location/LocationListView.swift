//
//  LocationListView.swift
//  Trippy
//
//  Created by QL on 13/3/21.
//

import SwiftUI

struct LocationListView: View {
    @ObservedObject var viewModel: LocationListViewModel

    var interactions: some View {
        HStack {
            NavigationLink(
        destination: LocationMapView(viewModel: .init(locationModel: viewModel.locationModel,
                                                      imageModel: viewModel.imageModel,
                                                      ratingModel: viewModel.ratingModel,
                                                      bucketModel: viewModel.bucketModel,
                                                      meetupModel: viewModel.meetupModel,
                                                      itineraryModel: viewModel.itineraryModel,
                                                      userId: viewModel.userId))
            ) {
                Text("Map")
            }
            Spacer()
            NavigationLink(
                destination: AddLocationView(viewModel: .init(locationModel: viewModel.locationModel))) {
                Text("Submit new location")
            }
        }.padding()
    }

    var recommended: some View {
        VStack(alignment: .leading) {
            Text("Recommended").font(.title2).fontWeight(.bold).foregroundColor(.green).padding(.horizontal)
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

    var locations: some View {
        List {
            ForEach(viewModel.locationCardViewModels, id: \.id) { locationCardViewModel in
                LocationCardView(viewModel: locationCardViewModel,
                                 showFullDetails: true,
                                 isHorizontal: true).frame(height: 200)
            }
        }
    }

    var body: some View {
            VStack {
                interactions
                if !viewModel.recommendedLocationViewModels.isEmpty {
                    recommended
                }
                locations
            }
            .onAppear(perform: viewModel.fetchRecommendedLocations)
    }
}
