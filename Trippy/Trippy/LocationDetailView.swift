//
//  LocationDetailView.swift
//  Trippy
//
//  Created by QL on 15/3/21.
//

import SwiftUI

struct LocationDetailView: View {
    @ObservedObject var viewModel: LocationDetailViewModel

    
    var body: some View {
        VStack {
            Image("Placeholder")
                .resizable()
                .aspectRatio(contentMode: .fit)
            HStack {
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
                    Text(viewModel.description)
                        .font(.body)
                        .foregroundColor(.primary)
                }
            }
            .padding()
        }
    }
}

struct LocationDetailView_Previews: PreviewProvider {
    static var previews: some View {
        LocationDetailView(viewModel: .init(location: PreviewLocations.locations[0]))
    }
}
