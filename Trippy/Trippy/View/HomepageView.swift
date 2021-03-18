//
//  HomepageView.swift
//  Trippy
//
//  Created by Audrey Felicio Anwar on 18/3/21.
//

import SwiftUI

struct HomepageView: View {
    @EnvironmentObject var session: SessionStore
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var homepageViewModel: HomepageViewModel
    var user: User

    var body: some View {
        NavigationView {
            VStack(spacing: 10) {
                Text("Welcome! \(user.username)")
                let bucketListVM = BucketListViewModel(bucketModel: homepageViewModel.bucketModel)
                let bucketListView = BucketListView(viewModel: bucketListVM)
                    .background(colorScheme == .dark ? Color.darkBackground : Color.lightBackground)
                let locationViewModel = LocationListViewModel(locationModel: homepageViewModel.locationModel)
                let locationListView = LocationListView(viewModel: locationViewModel)
                NavigationLink(destination: bucketListView) {
                    Text("BUCKET LIST")
                }
                NavigationLink(destination: locationListView) {
                    Text("LOCATIONS")
                }
                NavigationLink(destination: FollowersListView(viewModel: FollowersListViewModel(user: user))) {
                    Text("FOLLOWERS")
                }
                NavigationLink(destination: AccountPageView(
                                accountPageViewModel: AccountPageViewModel(session: session))) {
                    Text("ACCOUNT PAGE")
                }
                Button("SIGN OUT") {
                    _ = self.session.signOut()
                }
            }
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}

struct HomepageView_Previews: PreviewProvider {
    static var previews: some View {
        HomepageView(
            homepageViewModel: HomepageViewModel(),
            user: User(id: "1", email: "a@b.c", username: "abc", followersId: [], followingId: []))
    }
}
