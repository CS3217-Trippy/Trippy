//
//  HomepageView.swift
//  Trippy
//
//  Created by Audrey Felicio Anwar on 18/3/21.
//

import SwiftUI

struct HomepageView: View {
    @EnvironmentObject var session: FBSessionStore
    @ObservedObject var homepageViewModel: HomepageViewModel
    var user: User

    var body: some View {
        let bucketListVM = BucketListViewModel(bucketModel: homepageViewModel.bucketModel,
                                               imageModel: homepageViewModel.imageModel)
        let bucketListView = BucketListView(viewModel: bucketListVM)

        let locationViewModel = LocationListViewModel(locationModel: homepageViewModel.locationModel,
                                                      imageModel: homepageViewModel.imageModel)
        let locationListView = LocationListView(viewModel: locationViewModel)

        let accountPageViewModel = AccountPageViewModel(
            session: session,
            achievementModel: homepageViewModel.achievementsModel,
            imageModel: homepageViewModel.imageModel
        )
        let accountPageView = AccountPageView(
            accountPageViewModel: accountPageViewModel, user: user)

        let friendListVM = FriendsListViewModel(friendsListModel: homepageViewModel.friendsModel,
                                                imageModel: homepageViewModel.imageModel)
        let friendListView = FriendsListView(viewModel: friendListVM)

        NavigationView {
            VStack(spacing: 10) {
                Text("Welcome, \(user.username)")
                    .font(.title)

                NavigationLink(destination: bucketListView) {
                    Text("BUCKET LIST")
                }
                NavigationLink(destination: locationListView) {
                    Text("LOCATIONS")
                }
                NavigationLink(destination: friendListView) {
                    Text("FRIENDS")
                }
                NavigationLink(destination: accountPageView) {
                    Text("ACCOUNT PAGE")
                }
                NavigationLink(destination: AddFriendView(viewModel: AddFriendViewModel(session: session))) {
                    Text("ADD FRIEND")
                }
                Button("SIGN OUT") {
                    _ = self.session.signOut()
                }
            }
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}
