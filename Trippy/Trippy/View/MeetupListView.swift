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
            if viewModel.isEmpty {
                Text("No items in meetup list!")
            }
            CollectionView(data: $viewModel.meetupItemViewModels,
                           cols: 1, spacing: 10) { meetupViewModel in
                MeetupItemView(viewModel: meetupViewModel)
            }
        }
        .navigationTitle("Meetups")
    }
}
