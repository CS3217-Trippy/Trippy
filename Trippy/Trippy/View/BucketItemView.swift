import SwiftUI
import URLImage

struct BucketItemView: View {
    @State private var visited = false
    @ObservedObject var viewModel: BucketItemViewModel
    @EnvironmentObject var session: FBSessionStore

    var imageView: some View {
        if let image = viewModel.image {
            return AnyView(Image(uiImage: image).cardImageModifier()
            )
        } else {
            return AnyView(Image("Placeholder").cardImageModifier())
        }
    }

    var addMeetupView: some View {
        HStack {
            NavigationLink(
                destination: CreateMeetupView(viewModel:
                                                CreateMeetupViewModel(
                                                    bucketItem: viewModel.bucketItem,
                                                    session: session))
            ) {
                Text("Create meetup")
            }
            Spacer()
        }
    }

    var textView: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text(viewModel.locationName)
                .bold()
                .font(.headline)
            Text(viewModel.userDescription).fontWeight(.light)
            Text("Added on " + viewModel.dateAdded.dateTimeStringFromDate)
                .lineLimit(9)
            addMeetupView
            Image(systemName: "trash").foregroundColor(.red).onTapGesture {
                viewModel.remove()
            }
        }
    }

    var body: some View {
        RectangularCard(width: UIScreen.main.bounds.width - 10, height: 210, viewBuilder: {
            HStack(alignment: .center) {
                imageView
                textView
                Spacer()
            }
        })
    }
}
