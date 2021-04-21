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
                    Text(viewModel.averageRatingDescription)
                    .font(.caption)
                    .fontWeight(.black)
                    .foregroundColor(.secondary)
                }

                if showFullDetails {
                    Text(viewModel.caption)
                    .font(.caption)
                    .foregroundColor(.secondary)
                }
            }
            Spacer()
        }
    }

    var body: some View {
        NavigationLink(destination: LocationDetailView(viewModel: .init(location: viewModel.location,
                                                                        imageModel: viewModel.imageModel,
                                                                        ratingModel: viewModel.ratingModel))) {
                RectangularCard(image: viewModel.image,
                                isHorizontal: isHorizontal) {
                                    locationCardText.padding()

                }
        }
    }
}
