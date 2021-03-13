//
//  LocationListView.swift
//  Trippy
//
//  Created by QL on 13/3/21.
//

import SwiftUI

struct LocationListView: View {
    @ObservedObject var locationListViewModel: LocationListViewModel
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(locationListViewModel.locationCardViewModels) { locationCardViewModel in
                    LocationCardView(locationCardViewModel: locationCardViewModel)
                    
                }
            }
            .padding(.horizontal)
        }
    }
}

struct LocationListView_Previews: PreviewProvider {
    static var previews: some View {
        let previewModel = LocationModel(storage: PreviewLocationStorage())
        let locationListViewModel = LocationListViewModel(locationModel: previewModel)
        LocationListView(locationListViewModel: locationListViewModel)
    }
}
