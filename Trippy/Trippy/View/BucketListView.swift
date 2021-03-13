import SwiftUI

struct BucketListView: View {
    @ObservedObject var viewModel: BucketListViewModel
    var body: some View {
        VStack {
            Text("Bucket List")
            CollectionView(data: $viewModel.bucketViewModels, cols: 2, spacing: 10) { bucketViewModel in
                BucketItemView(viewModel: bucketViewModel)
            }
        }
    }
}
