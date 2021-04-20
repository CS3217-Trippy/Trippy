import SwiftUI

/// View of an itinerary item.
struct ItineraryItemView: View {
    @ObservedObject var viewModel: ItineraryItemViewModel
    @EnvironmentObject var session: FBSessionStore

    var textView: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text(viewModel.locationName)
                .bold()
                .font(.headline)
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
