//
//  MeetupItemView.swift
//  Trippy
//
//  Created by Lim Chun Yong on 13/4/21.
//

import SwiftUI

struct MeetupItemView: View {
    @ObservedObject var viewModel: MeetupItemViewModel
    @EnvironmentObject var session: FBSessionStore
    @Environment(\.presentationMode) var presentationMode
    let font = Font.body
    let showFullDetails: Bool
    let isHorizontal: Bool

    var textView: some View {
        let font: Font = showFullDetails ? Font.title : Font.body
    return HStack {
            VStack(alignment: .leading) {
                if showFullDetails {
                    Text(viewModel.locationCategory ?? "")
                    .font(.headline)
                    .foregroundColor(.secondary)
                }

                Text(viewModel.locationName ?? "")
                .font(font)
                .foregroundColor(.primary)
                .lineLimit(1)

                if showFullDetails {
                    Text(viewModel.dateOfMeetup)
                    .font(.caption)
                    .fontWeight(.black)
                    .foregroundColor(.secondary)
                }

                Image(systemName: "trash").foregroundColor(.red).padding(.top).onTapGesture {
                    do {
                        try viewModel.remove(userId: session.currentLoggedInUser?.id)
                    } catch {
                        print("error while removing")
                    }
                    presentationMode.wrappedValue.dismiss()
                }
            }
            Spacer()
    }
    }

    var body: some View {
            RectangularCard(
            image: viewModel.image,
            isHorizontal: isHorizontal) {
                VStack(alignment: .leading) {
                    textView.padding()
                }
            }
    }
}
