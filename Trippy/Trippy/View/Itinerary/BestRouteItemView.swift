//
//  BestRouteItemView.swift
//  Trippy
//
//  Created by Fidella Widjojo on 17/4/21.
//

import SwiftUI

/// View of a best route item.
struct BestRouteItemView: View {
    @ObservedObject var viewModel: ItineraryItemViewModel
    @EnvironmentObject var session: FBSessionStore

    var textView: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text(viewModel.location?.name ?? "")
                .bold()
                .font(.headline)
        }
    }

    var body: some View {
        GeometryReader { _ in
            RectangularCard(
                image: viewModel.image,
                isHorizontal: false
            ) {
                HStack(alignment: .center) {
                    textView
                    Spacer()
                }
            }
        }
    }
}
