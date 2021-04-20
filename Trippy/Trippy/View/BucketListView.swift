import SwiftUI

struct BucketListView: View {
    @ObservedObject var viewModel: BucketListViewModel
    var body: some View {
            List {
                if viewModel.isEmpty {
                    Text("No items in bucket list!")
                }
                ForEach(viewModel.bucketItemViewModels, id: \.id) { bucketViewModel in
                    BucketItemView(viewModel: bucketViewModel).frame(height: 200)
                }
            }.navigationTitle("Bucket List")
    }
}
