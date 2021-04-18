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

    var image: some View {
        Image("background")
            .resizable()
            .scaledToFill()
            .edgesIgnoringSafeArea(.all)
    }

    var information: some View {
        VStack(spacing: 10) {
            Text("Welcome, \(user.username)")
                .bold()
                .font(.largeTitle)
                .foregroundColor(Color(hex: "000000"))
        }
    }

    var interactions: some View {
        let hexColor = "001482"
        let bucketListVM = BucketListViewModel(bucketModel: homepageViewModel.bucketModel,
                                               imageModel: homepageViewModel.imageModel)
        let bucketListView = BucketListView(viewModel: bucketListVM)

        let locationViewModel = LocationListViewModel(locationModel: homepageViewModel.locationModel,
                                                      imageModel: homepageViewModel.imageModel,
                                                      ratingModel: homepageViewModel.ratingModel)
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

        let itineraryListVM = ItineraryListViewModel(itineraryModel: homepageViewModel.itineraryModel,
                                                     imageModel: homepageViewModel.imageModel)
        let itineraryListView = ItineraryListView(viewModel: itineraryListVM)

        return VStack(spacing: 10) {
            information
            NavigationLink(destination: bucketListView) {
                RaisedNavigationText(text: "BUCKET LIST", colorHex: hexColor).cornerRadius(10)
            }
            NavigationLink(destination: meetupListView) {
                RaisedNavigationText(text: "MEETUPS", colorHex: hexColor).cornerRadius(10)
            }
            NavigationLink(destination: locationListView) {
                RaisedNavigationText(text: "LOCATIONS", colorHex: hexColor).cornerRadius(10)
            }
            NavigationLink(destination: itineraryListView) {
                RaisedNavigationText(text: "ITINERARY", colorHex: hexColor).cornerRadius(10)
            }
            NavigationLink(destination: friendListView) {
                RaisedNavigationText(text: "FRIENDS", colorHex: hexColor).cornerRadius(10)
            }
            NavigationLink(destination: accountPageView) {
                RaisedNavigationText(text: "ACCOUNT PAGE", colorHex: hexColor).cornerRadius(10)
            }
            NavigationLink(destination: AddFriendView(viewModel: AddFriendViewModel(session: session))) {
                RaisedNavigationText(text: "ADD FRIEND", colorHex: hexColor).cornerRadius(10)
            }
            RaisedButton(child: "SIGN OUT", colorHex: hexColor) {
                _ = self.session.signOut()
            }.cornerRadius(10)
        }.zIndex(100)
    }

    var body: some View {

        NavigationView {
            ZStack {
                image
                interactions

            }
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}
