//
//  FollowersListView.swift
//  Trippy
//
//  Created by Fidella Widjojo on 16/03/21.
//

import SwiftUI

struct FollowersListView: View {
    @ObservedObject var viewModel: FollowersListViewModel
    var body: some View {
        VStack {
            Text("Followers List")
            CollectionView(data: $viewModel.followersList, cols: 1, spacing: 10) { followersItemViewModel in
                FollowersItemView(followersItemViewModel: followersItemViewModel)
            }
        }
    }
}
