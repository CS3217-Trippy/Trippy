import SwiftUI

struct BucketListView: View {
    @ObservedObject var viewModel: BucketListViewModel

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
        if let detailViewModel = viewModel.getLocationDetailViewModel(
            locationId: bucketItemViewModel.locationId ?? "") {
            return AnyView(NavigationLink(
                destination: LocationDetailView(viewModel: detailViewModel)

            ) {
                BucketItemView(viewModel: bucketItemViewModel)
            })
        } else {
            return AnyView(BucketItemView(viewModel: bucketItemViewModel))
        }
    }

    var body: some View {
        TabView {
            self.buildListView(viewModels: viewModel.bucketItemViewModels).tabItem {
                Label("Not completed", systemImage: "task")
            }

            self.buildListView(viewModels: viewModel.visitedBucketItemViewModels).tabItem {
                Label("Completed", systemImage: "taskCompleted")
            }

        }
        .navigationTitle("Bucket List")
    }
}
