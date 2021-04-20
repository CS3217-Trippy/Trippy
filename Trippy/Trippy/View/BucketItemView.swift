import SwiftUI

struct BucketItemView: View {
    @State private var visited = false
    @ObservedObject var viewModel: BucketItemViewModel
    @EnvironmentObject var session: FBSessionStore

    var textView: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(viewModel.locationName)
                    .bold()
                    .font(.headline)
                Text(viewModel.userDescription).fontWeight(.light)
                Text("Added on " + viewModel.dateAdded.dateTimeStringFromDate)
                    .lineLimit(9)
                Image(systemName: "trash").foregroundColor(.red).onTapGesture {
                    viewModel.remove()
                }
            }
            Spacer()
        }
    }

    var body: some View {
        RectangularCard(
                        image: viewModel.image,
                        isHorizontal: true
                        ) {
            textView.padding()
        }
    }
}
