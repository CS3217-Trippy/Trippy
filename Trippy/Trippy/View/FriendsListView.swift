//
//  FriendsListView.swift
//  Trippy
//
//  Created by Fidella Widjojo on 16/03/21.
//

import SwiftUI

struct FriendsListView: View {
    @ObservedObject var viewModel: FriendsListViewModel
    var body: some View {
        VStack {
                Text("Friends List")
                CollectionView(data: $viewModel.friendsList, cols: 1, spacing: 10) { friendsItemViewModel in
                    FriendsItemView(friendsItemViewModel: friendsItemViewModel)
                }
        }
    }
}
