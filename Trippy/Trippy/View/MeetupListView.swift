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
                if !viewModel.meetupItemViewModels.isEmpty {
                    VStack(alignment: .leading) {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(viewModel.meetupItemViewModels, id: \.id) { meetupViewModel in
                                    MeetupItemView(viewModel: meetupViewModel, isHorizontal: true)
                                }
                            }
                        }.frame(height: 200)
                    }
                }
                ForEach(viewModel.publicMeetupViewModels, id: \.id) { meetupViewModel in
                    MeetupItemView(viewModel: meetupViewModel, isHorizontal: false).frame(height: 200)
                }
            }
        }
        .navigationTitle("Meetups")
    }
}
