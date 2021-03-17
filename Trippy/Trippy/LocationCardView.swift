//
//  LocationCardView.swift
//  Trippy
//
//  Created by QL on 13/3/21.
//

import SwiftUI
import CoreLocation

struct LocationCardView: View {
    @ObservedObject var viewModel: LocationCardViewModel
    
    var body: some View {
        NavigationLink(destination: LocationDetailView(viewModel: .init(location: viewModel.location))) {
            LocationRectangularCard {
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
                            Text(viewModel.caption)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .layoutPriority(100)
                        Spacer()
                    }
                    .padding()
                }
            }
        }
    }
}

struct LocationCardView_Previews: PreviewProvider {
    static var previews: some View {
        let testLocation = PreviewLocations.locations[0]
        let locationCardViewModel = LocationCardViewModel(location: testLocation)
        LocationCardView(viewModel: locationCardViewModel)
    }
}
