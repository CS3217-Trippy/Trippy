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

        let meetupListVM = MeetupListViewModel(
            meetupModel: homepageViewModel.meetupModel,
            imageModel: homepageViewModel.imageModel
        )

        let meetupListView = MeetupListView(viewModel: meetupListVM)

        NavigationView {
            ZStack {
                Image("background")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                VStack(spacing: 10) {
                    Text("Welcome, \(user.username)")
                        .font(.title)

                    NavigationLink(destination: bucketListView) {
                        RaisedNavigationText(text: "BUCKET LIST")
                    }
                    NavigationLink(destination: meetupListView) {
                        RaisedNavigationText(text: "MEETUPS")
                    }
                    NavigationLink(destination: locationListView) {
                        RaisedNavigationText(text: "LOCATIONS")
                    }
                    NavigationLink(destination: friendListView) {
                        RaisedNavigationText(text: "FRIENDS")
                    }
                    NavigationLink(destination: accountPageView) {
                        RaisedNavigationText(text: "ACCOUNT PAGE")
                    }
                    NavigationLink(destination: AddFriendView(viewModel: AddFriendViewModel(session: session))) {
                        RaisedNavigationText(text: "ADD FRIEND")
                    }
                    RaisedButton(child: "SIGN OUT") {
                        _ = self.session.signOut()
                    }.padding()
                }.zIndex(100)
            }
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}
