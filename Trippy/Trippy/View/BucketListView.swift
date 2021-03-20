import SwiftUI

struct BucketListView: View {
    @ObservedObject var viewModel: BucketListViewModel
    var body: some View {
        VStack {
            if viewModel.isEmpty {
                Text("No items in bucket list!")
            }
            CollectionView(data: $viewModel.bucketItemViewModels, cols: 1, spacing: 10) { bucketViewModel in
                BucketItemView(viewModel: bucketViewModel)
            }
        }.navigationTitle("Bucket List")
    }
}
