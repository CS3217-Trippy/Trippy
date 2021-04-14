//
//  MeetupItemView.swift
//  Trippy
//
//  Created by Lim Chun Yong on 13/4/21.
//

import SwiftUI
import URLImage

struct MeetupItemView: View {
    @ObservedObject var viewModel: MeetupItemViewModel
    let font = Font.body
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
                .font(.headline)
                .foregroundColor(Color(.black))
            Text(viewModel.userDescription).font(font).foregroundColor(Color(.black))
            Text("Added on " + viewModel.dateAdded.dateTimeStringFromDate)
                .lineLimit(9).font(font).foregroundColor(Color(.black))
        }
    }

    var body: some View {
        NavigationLink(destination:
                        MeetupDetailView(viewModel: viewModel.meetupDetailViewModel)) {
                RectangularCard(width: UIScreen.main.bounds.width - 10, height: 210, viewBuilder: {
                    HStack(alignment: .center) {
                        imageView
                        textView
                        Spacer()
                    }
                })
        }

    }
}
