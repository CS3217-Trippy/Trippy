//
//  FriendsListView.swift
//  Trippy
//
//  Created by Fidella Widjojo on 16/03/21.
//

import SwiftUI

struct FriendsListView: View {
    @EnvironmentObject var session: FBSessionStore
    @ObservedObject var viewModel: FriendsListViewModel

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Spacer()
                    NavigationLink(destination: AddFriendView(viewModel: AddFriendViewModel(session: session))) {
                        Text("Add Friend")
                    }
                }
                List {
                    ForEach(viewModel.friendsList, id: \.id) { friendsItemViewModel in
                        FriendsItemView(friendsItemViewModel: friendsItemViewModel).frame(height: 200)
                    }
                }
            }
            .padding(.horizontal)
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}
