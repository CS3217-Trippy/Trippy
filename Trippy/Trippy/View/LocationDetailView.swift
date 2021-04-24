//
//  LocationDetailView.swift
//  Trippy
//
//  Created by QL on 15/3/21.
//

import SwiftUI

struct LocationDetailView: View {
    @ObservedObject var viewModel: LocationDetailViewModel
    @EnvironmentObject var session: FBSessionStore
    @State private var showSubmitRatingSheet = false

    var addBucketView: some View {
        NavigationLink(
            destination: AddBucketItemView(
                viewModel: .init(location: viewModel.location,
                                 bucketModel: viewModel.bucketModel,
                                 user: session.currentLoggedInUser))
        ) {
            Text("Add to bucketlist")
        }
    }

    var addItineraryView: some View {
        AddItineraryView(viewModel: .init(location: viewModel.location, user: session.currentLoggedInUser))
    }

    var addMeetupView: some View {
        NavigationLink(
            destination: CreateMeetupView(viewModel: .init(location: viewModel.location, session: session))
        ) {
            Text("Create Meetup")
        }
    }

    var addViews: some View {
        HStack {
            VStack {
                addBucketView
                addItineraryView
            }
            Spacer()
            addMeetupView
        }
    }

    var ratingSection: some View {
        HStack {
            Text(viewModel.averageRatingDescription)
            .font(.caption)
            .fontWeight(.black)
            .foregroundColor(.secondary)

            if let locationId = viewModel.location.id, let user = session.currentLoggedInUser?.id {
                Button(action: { showSubmitRatingSheet.toggle() }) {
                    Text("Submit rating")
                    .font(.caption)
                }
                .padding()
                .sheet(isPresented: $showSubmitRatingSheet) {
                    SubmitRatingView(viewModel: SubmitRatingViewModel(
                                        locationId: locationId,
                                        userId: user,
                                        ratingModel: viewModel.ratingModel
                    ))
                }
            }
        }
    }

    var pageContent: some View {
        VStack(alignment: .leading) {
            Text(viewModel.category)
            .font(.headline)
            .foregroundColor(.secondary)

            Text(viewModel.title)
            .font(.title)
            .fontWeight(.black)
            .foregroundColor(.primary)

            ratingSection

            Text(viewModel.address)
            .font(.caption)
            .foregroundColor(.secondary)

            Divider()

            HStack {
                if viewModel.isInBucketlist {
                    Text("You have added this location to your bucketlist.")
                        .font(.caption)
                } else {
                    Text("This location is not in your bucketlist.")
                        .font(.caption)
                }
                if let user = session.currentLoggedInUser {
                    NavigationLink(
                        destination: BucketListView(viewModel: .init(
                            bucketModel: viewModel.bucketModel,
                            imageModel: viewModel.imageModel,
                            meetupModel: viewModel.meetupModel,
                            locationList: .init(locationModel: viewModel.locationModel,
                                                imageModel: viewModel.imageModel,
                                                ratingModel: viewModel.ratingModel,
                                                meetupModel: viewModel.meetupModel,
                                                bucketModel: viewModel.bucketModel,
                                                userId: user.id), user: user
                        ))) {
                        Text("Manage bucketlist")
                            .font(.caption)
                    }
                }
            }
            HStack {
                if let date = viewModel.meetupDate {
                    Text("You have \(viewModel.upcomingMeetups.count) upcoming meetups here including one on \(date)")
                        .foregroundColor(.orange)
                        .font(.caption)
                    NavigationLink(
                        destination: MeetupListView(viewModel: .init(
                            meetupModel: viewModel.meetupModel, imageModel: viewModel.imageModel,
                            locationList: .init(locationModel: viewModel.locationModel,
                                                imageModel: viewModel.imageModel,
                                                ratingModel: viewModel.ratingModel,
                                                meetupModel: viewModel.meetupModel,
                                                bucketModel: viewModel.bucketModel,
                                                userId: session.currentLoggedInUser?.id)
                        ))) {
                        Text("Manage meetups")
                            .font(.caption)
                    }

                } else {
                    Text("You have no upcoming meetup here.")
                        .font(.caption)
                }
            }

            Divider()

            Text("About")
            .font(.title2)
            .fontWeight(.bold)

            Text(viewModel.description)
            .font(.body)
            .foregroundColor(.primary)
        }
    }

    var body: some View {
        ScrollView {
            VStack {
               addViews
                if let image = viewModel.image {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                } else {
                    Image("Placeholder")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                }

                WeatherSectionView(viewModel: WeatherSectionViewModel(coordinates: viewModel.locationCoordinates))

                HStack {
                    pageContent
                    Spacer()
                }
                .padding()
            }
        }
    }
}
