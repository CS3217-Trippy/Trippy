import SwiftUI

struct BucketItemView: View {
    @State private var visited = false
    @ObservedObject var viewModel: BucketItemViewModel
    @EnvironmentObject var session: FBSessionStore

    var textView: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(viewModel.locationName ?? "")
                    .bold()
                    .font(.headline)
                Text(viewModel.userDescription).fontWeight(.light)
                Text("Added on " + viewModel.dateAdded.dateTimeStringFromDate)
                    .lineLimit(9)
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
            Spacer()
        }
    }

    var card: some View {
        RectangularCard(
            image: viewModel.image,
            isHorizontal: true
        ) {
            textView.padding()
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
