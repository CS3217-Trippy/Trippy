import SwiftUI

/// View of a itinerary list..
struct ItineraryListView: View {
    @ObservedObject var viewModel: ItineraryListViewModel
    @State private var showingBestRoute = false

    var bestRouteView: some View {
        VStack {
            Text("Here's the best route to minimize your travel distance:")
                .font(.title)
                .fontWeight(.bold)
            List {
                ForEach(viewModel.bestRouteViewModels) { bestRouteViewModel in
                    BestRouteItemView(viewModel: bestRouteViewModel)
                }
                .frame(height: 210)
            }
            Text("By following this route you will travel a total of "
                    + String(format: "%.2f", viewModel.bestRouteCost / 1_000) + "km")
                .fontWeight(.semibold)
            Spacer()
        }.padding()
    }

    var body: some View {
        VStack {
            HStack {
                Spacer()
                    Button("Find best route") {
                        viewModel.getBestRoute()
                        showingBestRoute = true
                    }.sheet(isPresented: $showingBestRoute) {
                        bestRouteView
                    }
            }.padding()
            if viewModel.isEmpty {
                Text("No items in itinerary list!")
            }
            List {
                ForEach(viewModel.itineraryItemViewModels, id: \.id) { itineraryViewModel in
                    ItineraryItemView(viewModel: itineraryViewModel).frame(height: 200)
                }
            }
        }.navigationTitle("Itinerary")
    }
}
