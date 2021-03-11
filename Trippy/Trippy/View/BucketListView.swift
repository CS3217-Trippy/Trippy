import SwiftUI

struct BucketListView: View {
    @ObservedObject var viewModel: BucketListViewModel
    var body: some View {
        VStack {
            Text("Bucket List")
            List {
                ForEach(viewModel.bucketViewModels) { bucketViewModel in
                    BucketItemView(viewModel: bucketViewModel)
                }
            }
        }
    }
}
