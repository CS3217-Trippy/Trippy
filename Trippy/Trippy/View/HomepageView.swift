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
                Text("Welcome, \(user.username)")
                    .font(.title)
                let bucketListVM = BucketListViewModel(bucketModel: homepageViewModel.bucketModel)
                let bucketListView = BucketListView(viewModel: bucketListVM)
                    .background(colorScheme == .dark ? Color.darkBackground : Color.lightBackground)
                let locationViewModel = LocationListViewModel(locationModel: homepageViewModel.locationModel)
                let locationListView = LocationListView(viewModel: locationViewModel)
                let accountPageView = AccountPageView(
                    accountPageViewModel: AccountPageViewModel(session: session), user: user)
                NavigationLink(destination: bucketListView) {
                    Text("BUCKET LIST")
                }
                NavigationLink(destination: locationListView) {
                    Text("LOCATIONS")
                }
                NavigationLink(destination: FriendsListView(viewModel: FriendsListViewModel(session: session))) {
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

struct HomepageView_Previews: PreviewProvider {
    static var previews: some View {
        HomepageView(
            homepageViewModel: HomepageViewModel(),
            user: User(id: "1", email: "a@b.c", username: "abc", friendsId: []))
    }
}
