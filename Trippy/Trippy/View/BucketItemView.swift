import SwiftUI
import URLImage

struct BucketItemView: View {
    @State private var visited = false
    var viewModel: BucketItemViewModel
    var body: some View {
        let bucketItem = viewModel.bucketItem
        let url = URL(string: bucketItem.locationImage)
        RectangularCard(width: UIScreen.main.bounds.width - 10, height: 210, viewBuilder: {
            HStack(alignment: .center) {
                if let unwrappedUrl = url {
                    URLImage(url: unwrappedUrl,
                             content: { image in
                                image
                                    .renderingMode(.original)
                                    .resizable()
                                    .frame(width: 200, height: 200)
                                    .cornerRadius(16)
                                    .padding(10)
                             })
                }
                VStack(alignment: .leading, spacing: 10) {
                    Text(bucketItem.locationName)
                        .bold()
                        .font(.headline)
                    Text("Added on " + bucketItem.dateAdded.dateTimeStringFromDate)
                        .lineLimit(9)
                }
                Spacer()
            }
        })
    }
}
