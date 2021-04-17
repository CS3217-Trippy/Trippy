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
        VStack {
            List {
                if !viewModel.publicMeetupViewModels.isEmpty {
                    Text("Public Meetups")
                    VStack(alignment: .leading) {
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

                Text("Upcoming Meetups")
    
                ForEach(viewModel.meetupItemViewModels, id: \.id) { meetupViewModel in
                    MeetupItemView(viewModel: meetupViewModel,
                                   showFullDetails: true,
                                   isHorizontal: false).frame(height: 200)
                }
            }
        }
        .navigationTitle("Meetups")
    }
}
