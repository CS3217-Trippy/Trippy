//
//  MeetupListView.swift
//  Trippy
//
//  Created by Lim Chun Yong on 13/4/21.
//

import Foundation
import SwiftUI

struct MeetupListView: View {
    @ObservedObject var viewModel: MeetupListViewModel
    var body: some View {
            List {

                if !viewModel.publicMeetupViewModels.isEmpty {
                    VStack(alignment: .leading) {
                        Text("Public meetups").font(.title2).fontWeight(.bold).foregroundColor(.green)
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(viewModel.publicMeetupViewModels, id: \.id) { meetupViewModel in
                                    MeetupItemView(viewModel: meetupViewModel,
                                                   showFullDetails: false,
                                                   isHorizontal: true)
                                }
                            }
                        }.frame(height: 200)
                    }
                }
                ForEach(viewModel.meetupItemViewModels, id: \.id) { meetupViewModel in
                    MeetupItemView(viewModel: meetupViewModel,
                                   showFullDetails: true,
                                   isHorizontal: true).frame(height: 200)
                }
            }.navigationTitle("Meetups")

    }
}
