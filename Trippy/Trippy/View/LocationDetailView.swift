//
//  LocationDetailView.swift
//  Trippy
//
//  Created by QL on 15/3/21.
//

import SwiftUI
import URLImage

struct LocationDetailView: View {
    @ObservedObject var viewModel: LocationDetailViewModel
    @EnvironmentObject var session: SessionStore

    var addBucketView: some View {
        HStack {
            NavigationLink(
            destination: AddBucketItemView(viewModel: .init(location: viewModel.location, user: session.session))) {
            Text("Add to bucketlist")
            }
            Spacer()
        }.padding(10)
    }

    var pageContent: some View {
        VStack(alignment: .leading) {
            Text("Sample Category Name")
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
                if let url = viewModel.location.imageURL {
                    URLImage(url: url) { image in
                        image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                    }
                } else {
                    Image("Placeholder")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                }

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
        LocationDetailView(viewModel: .init(location: PreviewLocations.locations[0]))
    }
}
