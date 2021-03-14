import SwiftUI

struct BucketListView: View {
    @ObservedObject var viewModel: BucketListViewModel
    var body: some View {
        VStack {
            Text("Bucket List")
            CollectionView(data: $viewModel.bucketItemViewModels, cols: 1, spacing: 10) { bucketViewModel in
                BucketItemView(viewModel: bucketViewModel)
            }
        }
    }
}

