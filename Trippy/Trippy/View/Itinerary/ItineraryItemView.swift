import SwiftUI

/// View of an itinerary item.
struct ItineraryItemView: View {
    @ObservedObject var viewModel: ItineraryItemViewModel
    @EnvironmentObject var session: FBSessionStore

    var textView: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text(viewModel.location?.name ?? "")
                .bold()
                .font(.headline)
            if let upcomingMeetup = viewModel.upcomingMeetup {
                Text("Upcoming Meetup")
                Text(upcomingMeetup.meetupDate, style: .date)
            } else {
                Text("No upcoming meetups")
            }
        }
    }

    var leave: some View {
        ButtonWithConfirmation(buttonName: nil, warning: nil, image: "trash") {
            viewModel.remove()
        }
    }

    var card: some View {
        RectangularCard(
            image: viewModel.image, isHorizontal: true) {
            HStack(alignment: .center) {
                textView
                Spacer()
                leave
            }
        }
    }

    var body: some View {
        if let detailViewModel = viewModel.locationDetailViewModel {
            AnyView(
                NavigationLink(destination: LocationDetailView(viewModel: detailViewModel)) {
                    card
                }
            )
        } else {
            card
        }
    }
}
