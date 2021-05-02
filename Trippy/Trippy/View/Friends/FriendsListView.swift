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
    @State private var selectedTab = 0

    var friendList: some View {
        List {
            ForEach(viewModel.friendsList, id: \.id) { friendsItemViewModel in
                FriendsItemView(friendsItemViewModel: friendsItemViewModel).frame(height: 200)
            }
        }
    }

    var friendRequests: some View {
        List {
            ForEach(viewModel.friendRequests, id: \.id) { friendsItemViewModel in
                FriendsItemView(friendsItemViewModel: friendsItemViewModel).frame(height: 200)
            }
        }
    }

    var body: some View {
        VStack {
            TopTabBar(tabs: .constant(["Friends", "Friend Requests"]),
                      selection: $selectedTab,
                      underlineColor: .blue)
            HStack {
                Spacer()
                NavigationLink(destination: AddFriendView(viewModel: AddFriendViewModel(session: session))) {
                    Text("Add Friend")
                }
            }
            if selectedTab == 0 {
                friendList
            } else {
                friendRequests
            }
        }.navigationTitle("Friends")
        .padding(.horizontal)
    }
}
