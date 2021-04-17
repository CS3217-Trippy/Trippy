//
//  BestRouteItemView.swift
//  Trippy
//
//  Created by Fidella Widjojo on 17/4/21.
//

/**
 View of a best route item.
*/
import SwiftUI

struct BestRouteItemView: View {
    @ObservedObject var viewModel: ItineraryItemViewModel
    @EnvironmentObject var session: FBSessionStore

    var imageView: some View {
        if let image = viewModel.image {
            return AnyView(Image(uiImage: image).cardImageModifier()
            )
        } else {
            return AnyView(Image("Placeholder").cardImageModifier())
        }
    }

    var textView: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text(viewModel.locationName)
                .bold()
                .font(.headline)
        }
    }

    var body: some View {
        GeometryReader { geo in
            RectangularCard(width: geo.frame(in: .global).width - 10, height: 210, viewBuilder: {
                HStack(alignment: .center) {
                    imageView
                    textView
                    Spacer()
                }
            })
        }
    }
}
