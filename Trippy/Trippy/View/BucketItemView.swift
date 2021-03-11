import SwiftUI

struct BucketItemView: View {
    @State private var visited = false
    var viewModel: BucketItemViewModel
    var body: some View {
        Text(viewModel.bucketItem.locationName)
    }
}
