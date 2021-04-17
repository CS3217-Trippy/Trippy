//
//  LocationDetailView.swift
//  Trippy
//
//  Created by QL on 15/3/21.
//

import SwiftUI

struct LocationDetailView: View {
    @ObservedObject var viewModel: LocationDetailViewModel
    @EnvironmentObject var session: FBSessionStore

    var addBucketView: some View {
        HStack {
            NavigationLink(
                destination: AddBucketItemView(
                    viewModel: .init(location: viewModel.location, user: session.currentLoggedInUser))
            ) {
                Text("Add to bucketlist")
            }
            Spacer()
        }.padding(10)
    }

    var pageContent: some View {
        VStack(alignment: .leading) {
            Text(viewModel.category)
            .font(.headline)
            .foregroundColor(.secondary)

            Text(viewModel.title)
            .font(.title)
            .fontWeight(.black)
            .foregroundColor(.primary)

            Text(viewModel.address)
            .font(.caption)
            .foregroundColor(.secondary)

            Divider()

            Text("About")
            .font(.title2)
            .fontWeight(.bold)

            Text(viewModel.description)
            .font(.body)
            .foregroundColor(.primary)
        }
    }

    var body: some View {
        ScrollView {
            VStack {
               addBucketView
                if let image = viewModel.image {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                } else {
                    Image("Placeholder")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                }

                WeatherSectionView(viewModel: WeatherSectionViewModel(coordinates: viewModel.locationCoordinates))

                HStack {
                    pageContent
                    Spacer()
                }
                .padding()
            }
        }
    }
}

struct LocationDetailView_Previews: PreviewProvider {
    static var previews: some View {
        LocationDetailView(viewModel: .init(location: PreviewLocations.locations[0],
                                            imageModel: ImageModel(storage: FBImageStorage())))
    }
}
