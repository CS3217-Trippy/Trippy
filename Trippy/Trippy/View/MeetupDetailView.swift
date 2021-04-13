//
//  MeetupDetailView.swift
//  Trippy
//
//  Created by Lim Chun Yong on 13/4/21.
//

import Foundation

import SwiftUI

struct MeetupDetailView: View {
    @ObservedObject var viewModel: MeetupDetailViewModel
    @EnvironmentObject var session: FBSessionStore
    @Environment(\.presentationMode) var presentationMode
    var pageContent: some View {
        VStack(alignment: .leading) {
            Text(viewModel.category)
            .font(.headline)
            .foregroundColor(.secondary)

            Text(viewModel.title)
            .font(.title)
            .fontWeight(.black)
            .foregroundColor(.primary)

            Text(viewModel.host)
            .font(.caption)
            .foregroundColor(.secondary)

            Divider()

            Text("About")
            .font(.title2)
            .fontWeight(.bold)

            Text(viewModel.description)
            .font(.body)
            .foregroundColor(.primary)

            Image(systemName: "trash").foregroundColor(.red).onTapGesture {
                do {
                    try viewModel.remove(userId: session.currentLoggedInUser?.id)
                } catch {
                    print("error while removing")
                }
                presentationMode.wrappedValue.dismiss()
            }
        }
    }

    var body: some View {
        ScrollView {
            VStack {
                if let image = viewModel.image {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
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
