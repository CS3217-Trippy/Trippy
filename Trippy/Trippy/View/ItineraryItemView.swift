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
            Image(systemName: "trash").foregroundColor(.red).onTapGesture {
                viewModel.remove()
            }
        }
    }

    var body: some View {
        RectangularCard(
            image: viewModel.image, isHorizontal: true) {
            HStack(alignment: .center) {
                textView
                Spacer()
            }
        }
    }
}
