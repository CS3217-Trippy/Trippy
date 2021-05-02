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

    var body: some View {
        let locationViewModel = LocationListViewModel(locationModel: homepageViewModel.locationModel,
                                                      imageModel: homepageViewModel.imageModel,
                                                      ratingModel: homepageViewModel.ratingModel,
                                                      meetupModel: homepageViewModel.meetupModel,
                                                      bucketModel: homepageViewModel.bucketModel,
                                                      itineraryModel: homepageViewModel.itineraryModel,
                                                      userId: homepageViewModel.userId)
        let locationListView = LocationListView(viewModel: locationViewModel)

        let accountPageViewModel = AccountPageViewModel(
            session: session,
            achievementModel: homepageViewModel.achievementsModel, user: session.currentLoggedInUser,
            imageModel: homepageViewModel.imageModel
        )
        let accountPageView = AccountPageView(
            acccountPageViewModel: accountPageViewModel)

        let friendListVM = FriendsListViewModel(friendsListModel: homepageViewModel.friendsModel,
                                                imageModel: homepageViewModel.imageModel,
                                                meetupModel: homepageViewModel.meetupModel,
                                                locationModel: homepageViewModel.locationModel,
                                                user: user)
        let friendListView = FriendsListView(viewModel: friendListVM)

        let meetupListVM = MeetupListViewModel(
            meetupModel: homepageViewModel.meetupModel,
            imageModel: homepageViewModel.imageModel,
            locationList: locationViewModel
        )

        let bucketListVM = BucketListViewModel(bucketModel: homepageViewModel.bucketModel,
                                               imageModel: homepageViewModel.imageModel,
                                               meetupModel: homepageViewModel.meetupModel,
                                               locationList: locationViewModel,
                                               user: user)
        let bucketListView = BucketListView(viewModel: bucketListVM)

        let meetupListView = MeetupListView(viewModel: meetupListVM)

        let itineraryListVM = ItineraryListViewModel(itineraryModel: homepageViewModel.itineraryModel,
                                                     imageModel: homepageViewModel.imageModel,
                                                     meetupModel: homepageViewModel.meetupModel,
                                                     locationModel: homepageViewModel.locationModel,
                                                     locationList: locationViewModel,
                                                     user: user)
        let itineraryListView = ItineraryListView(viewModel: itineraryListVM)

        return TabView {
            NavigationView {
                locationListView
            }.navigationViewStyle(StackNavigationViewStyle())
            .tabItem {
                Label("Locations", systemImage: "list.dash")
            }

            NavigationView {
                bucketListView
            }.navigationViewStyle(StackNavigationViewStyle())
            .tabItem {
                Label("Bucket List", systemImage: "heart")
            }

            NavigationView {
                meetupListView

            }.navigationViewStyle(StackNavigationViewStyle()).tabItem {
                Label("Meetups", systemImage: "figure.walk")
            }

            NavigationView {
                itineraryListView
            }.navigationViewStyle(StackNavigationViewStyle())
            .tabItem {
                Label("Itinerary", systemImage: "location")
            }

            NavigationView {
                friendListView
            }.navigationViewStyle(StackNavigationViewStyle())
            .tabItem {
                Label("Friends", systemImage: "person.3.fill")
            }

            NavigationView {
                accountPageView
            }.navigationViewStyle(StackNavigationViewStyle())
            .tabItem {
                Label("Account", systemImage: "person")
            }
        }
    }

}
