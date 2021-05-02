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
    @State private var selectedTab = 0

    private func buildItemView(meetupViewModel: MeetupItemViewModel,
                               showFullDetails: Bool,
                               isHorizontal: Bool) -> some View {
        MeetupItemView(
                        viewModel: meetupViewModel,
                        showFullDetails: showFullDetails,
                        isHorizontal: isHorizontal)
    }

    func buildListView(viewModels: [MeetupItemViewModel], isUpcoming: Bool) -> some View {
        List {
            if isUpcoming && viewModel.hasPublicMeetups {
                VStack(alignment: .leading) {
                    Text("Public meetups").font(.title2).fontWeight(.bold).foregroundColor(.green).padding(.horizontal)
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(viewModel.publicMeetupViewModels, id: \.id) { meetupViewModel in
                                buildItemView(meetupViewModel: meetupViewModel,
                                              showFullDetails: false,
                                              isHorizontal: false)
                            }
                        }
                    }.frame(height: 300)
                }
            }
            if viewModels.isEmpty {
                Text("No Meetups joined!")
            }
            ForEach(viewModels, id: \.id) { meetupViewModel in
                self.buildItemView(meetupViewModel: meetupViewModel,
                                   showFullDetails: true,
                                   isHorizontal: true).frame(height: 200)
            }
        }
    }

    var body: some View {
        VStack {
            TopTabBar(tabs: .constant(["Upcoming", "Past"]),
                      selection: $selectedTab,
                      underlineColor: .blue)
            if selectedTab == 0 {
                self.buildListView(viewModels: viewModel.currentMeetupItemViewModels, isUpcoming: true)
            } else {
                self.buildListView(viewModels: viewModel.pastMeetupItemViewModels, isUpcoming: false)
            }
        }.navigationTitle("Meetups")
    }
}
