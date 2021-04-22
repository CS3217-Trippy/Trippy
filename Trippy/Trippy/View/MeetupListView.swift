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

    func buildListView(viewModels: [MeetupItemViewModel], isUpcoming: Bool) -> some View {
        List {
            if isUpcoming {
                VStack(alignment: .leading) {
                    Text("Public meetups").font(.title2).fontWeight(.bold).foregroundColor(.green).padding(.horizontal)
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
            if viewModels.isEmpty {
                Text("No Meetups joined!")
            }
            ForEach(viewModels, id: \.id) { meetupViewModel in
                MeetupItemView(viewModel: meetupViewModel,
                               showFullDetails: true,
                               isHorizontal: true).frame(height: 200)
            }
        }
    }

    var createMeetup: some View {
        NavigationLink(
            destination: LocationListView(viewModel: viewModel.locationListViewModel)
        ) {
            Text("Create Meetup").padding(.horizontal)
        }
    }

    var body: some View {
        HStack {
            createMeetup
            Spacer()
        }
            TabView {
                self.buildListView(viewModels: viewModel.currentMeetupItemViewModels, isUpcoming: true).tabItem {
                    Label("Upcoming", systemImage: "taskCompleted")
                }
                self.buildListView(viewModels: viewModel.pastMeetupItemViewModels, isUpcoming: false).tabItem {
                    Label("Past", systemImage: "taskCompleted")
                }

            }.navigationTitle("Meetups")
    }
}
