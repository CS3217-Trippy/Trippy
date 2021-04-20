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
        List {
            Text("Friends List")
            ForEach(viewModel.friendsList, id: \.id) { friendsItemViewModel in
                FriendsItemView(friendsItemViewModel: friendsItemViewModel).frame(height: 200)
            }
        }
    }
}
