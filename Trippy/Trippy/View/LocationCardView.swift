//
//  LocationCardView.swift
//  Trippy
//
//  Created by QL on 13/3/21.
//

import SwiftUI
import CoreLocation
import URLImage

struct LocationCardView: View {
    @ObservedObject var viewModel: LocationCardViewModel
    let showFullDetails: Bool
    let isHorizontal: Bool

    var locationCardText: some View {
        let font: Font = showFullDetails ? Font.title : Font.body
        return HStack {
            VStack(alignment: .leading) {
                if showFullDetails {
                    Text(viewModel.category)
                    .font(.headline)
                    .foregroundColor(.secondary)
                }

                Text(viewModel.title)
                .font(font)
                .foregroundColor(.primary)
                .lineLimit(1)

                if showFullDetails {
                    Text(viewModel.caption)
                    .font(.caption)
                    .foregroundColor(.secondary)
                }
            }
            Spacer()
        }
    }

    var cardBody: some View {
         if let image = viewModel.image {
            return AnyView(
                Image(uiImage: image).locationImageModifier()
            )
        } else {
            return AnyView(Image("Placeholder")
            .locationImageModifier())
        }
    }

    var body: some View {
        NavigationLink(destination: LocationDetailView(viewModel: .init(location: viewModel.location,
                                                                        imageModel: viewModel.imageModel ))) {
            if isHorizontal {
                HStack {
                    cardBody
                    locationCardText
                    .padding()
                }
                .padding([.top, .horizontal])
            } else {
                VStack {
                    cardBody
                    locationCardText
                    .padding()
                }
                .padding([.top, .horizontal])
            }

        }
    }
}

struct LocationCardView_Previews: PreviewProvider {
    static var previews: some View {
        let testLocation = PreviewLocations.locations[0]
        let locationCardViewModel = LocationCardViewModel(location: testLocation,
                                                          imageModel: ImageModel(storage: FBImageStorage()))
        LocationCardView(viewModel: locationCardViewModel, showFullDetails: true, isHorizontal: true)
    }
}
