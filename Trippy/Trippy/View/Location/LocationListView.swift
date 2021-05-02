//
//  LocationListView.swift
//  Trippy
//
//  Created by QL on 13/3/21.
//

import SwiftUI

struct LocationListView: View {
    @ObservedObject var viewModel: LocationListViewModel

    var body: some View {
            VStack {
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
                }
                .padding()
                if !viewModel.recommendedLocationViewModels.isEmpty {
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
                List {
                    ForEach(viewModel.locationCardViewModels, id: \.id) { locationCardViewModel in
                        LocationCardView(viewModel: locationCardViewModel,
                                         showFullDetails: true,
                                         isHorizontal: true).frame(height: 200)
                    }
                }
            }
            .onAppear(perform: viewModel.fetchRecommendedLocations)

    }
}
