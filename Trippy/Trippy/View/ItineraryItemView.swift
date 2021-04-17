import SwiftUI
import URLImage

struct ItineraryItemView: View {
    @ObservedObject var viewModel: ItineraryItemViewModel
    @EnvironmentObject var session: FBSessionStore

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
