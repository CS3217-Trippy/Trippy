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

    var bucketlistSection: some View {
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
                                            itineraryModel: viewModel.itineraryModel,
                                            userId: user.id
                        ), user: user
                    ))) {
                    Text("Manage bucketlist")
                        .font(.caption)
                }
            }
        }
    }

    var meetupSection: some View {
        HStack {
            if let date = viewModel.meetupDate {
                if viewModel.upcomingMeetups.count > 1 {
                    Text("You have \(viewModel.upcomingMeetups.count) upcoming meetups here including one on \(date).")
                        .foregroundColor(.orange)
                        .font(.caption)
                } else {
                    Text("You have an upcoming meetup here on \(date).")
                        .foregroundColor(.orange)
                        .font(.caption)
                }
            } else {
                Text("You have no upcoming meetups here.")
                    .font(.caption)
            }
            NavigationLink(
                destination: MeetupListView(viewModel: .init(
                    meetupModel: viewModel.meetupModel, imageModel: viewModel.imageModel,
                    locationList: .init(locationModel: viewModel.locationModel,
                                        imageModel: viewModel.imageModel,
                                        ratingModel: viewModel.ratingModel,
                                        meetupModel: viewModel.meetupModel,
                                        bucketModel: viewModel.bucketModel,
                                        itineraryModel: viewModel.itineraryModel,
                                        userId: session.currentLoggedInUser?.id)
                ))) {
                Text("Manage meetups")
                    .font(.caption)
            }
        }
    }

    var itinerarySection: some View {
        HStack {
            if viewModel.numItinerary > 1 {
                Text("You have \(viewModel.numItinerary) itineraries with this location.")
                    .font(.caption)

            } else if viewModel.numItinerary == 1 {
                Text("You have an itinerary with this location.")
                    .font(.caption)
            } else {
                Text("You have no itineraries with this location.")
                    .font(.caption)
            }
            if let user = session.currentLoggedInUser {
                NavigationLink(
                    destination: ItineraryListView(viewModel: .init(
                        itineraryModel: viewModel.itineraryModel,
                        imageModel: viewModel.imageModel,
                        meetupModel: viewModel.meetupModel,
                        locationModel: viewModel.locationModel,
                        locationList: .init(locationModel: viewModel.locationModel,
                                            imageModel: viewModel.imageModel,
                                            ratingModel: viewModel.ratingModel,
                                            meetupModel: viewModel.meetupModel,
                                            bucketModel: viewModel.bucketModel,
                                            itineraryModel: viewModel.itineraryModel,
                                            userId: session.currentLoggedInUser?.id),
                        user: user
                    ))) {
                    Text("Manage itineraries")
                        .font(.caption)
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

            Group {
                bucketlistSection
                meetupSection
                itinerarySection
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
