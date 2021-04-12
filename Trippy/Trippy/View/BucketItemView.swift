import SwiftUI
import URLImage

struct BucketItemView: View {
    @State private var visited = false
    var viewModel: BucketItemViewModel

    var imageView: some View {
        if let image = viewModel.image {
            return AnyView(Image(uiImage: image).cardImageModifier()
            )
        } else {
            return AnyView(Image("Placeholder").cardImageModifier())
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
