import SwiftUI

struct BucketListView: View {
    @ObservedObject var viewModel: BucketListViewModel
    @State private var selectedTab = 0
    func buildListView(viewModels: [BucketItemViewModel]) -> some View {
        List {
            if viewModels.isEmpty {
                Text("No bucket items!")
            }
            ForEach(viewModels, id: \.id) { bucketViewModel in
                self.buildItemView(bucketItemViewModel: bucketViewModel).frame(height: 200)
            }
        }
    }

    private func buildItemView(bucketItemViewModel: BucketItemViewModel) -> some View {
        BucketItemView(viewModel: bucketItemViewModel)
    }

    var body: some View {
        VStack {
            TopTabBar(
                tabs: .constant(["Current", "Completed"]),
                selection: $selectedTab,
                underlineColor: .blue)
            if selectedTab == 0 {
                self.buildListView(viewModels: viewModel.bucketItemViewModels)
            } else {
                self.buildListView(viewModels: viewModel.visitedBucketItemViewModels)
            }
        }.navigationTitle("Bucket List")
    }
}
