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
    let showFullDetails: Bool
    let isHorizontal: Bool

    var imageView: some View {
        if let image = viewModel.image {
            return AnyView(
                Image(uiImage: image).locationImageModifier()
            )
        } else {
            return AnyView(Image("Placeholder").locationImageModifier())
        }
    }

    var textView: some View {
        let font: Font = showFullDetails ? Font.title : Font.body
        return HStack {
            VStack(alignment: .leading) {
                if showFullDetails {
                    Text(viewModel.locationCategory)
                    .font(.headline)
                    .foregroundColor(.secondary)
                }

                Text(viewModel.locationName)
                .font(font)
                .foregroundColor(.primary)
                .lineLimit(1)

                if showFullDetails {
                    Text(viewModel.dateOfMeetup)
                    .font(.caption)
                    .foregroundColor(.secondary)
                }
            }
            Spacer()
        }
    }

    var body: some View {
        NavigationLink(destination: MeetupDetailView(viewModel: viewModel.meetupDetailViewModel)) {
            if isHorizontal {
                VStack {
                    imageView
                    textView
                    .padding()
                }
                .padding([.top, .horizontal])
            } else {
                    HStack {
                        imageView
                        textView
                        .padding()
                    }
                    .padding([.top, .horizontal])
            }
        }

    }
}
