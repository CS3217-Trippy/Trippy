//
//  LocationCardView.swift
//  Trippy
//
//  Created by QL on 13/3/21.
//

import SwiftUI
import CoreLocation

struct LocationCardView: View {
    var locationCardViewModel: LocationCardViewModel
    
    var body: some View {
        VStack {
            Image("Placeholder")
            Text(locationCardViewModel.location.name)
        }
    }
}

struct LocationCardView_Previews: PreviewProvider {
    static var previews: some View {
        let testLocation = PreviewLocations.locations[0]
        let locationCardViewModel = LocationCardViewModel(location: testLocation)
        LocationCardView(locationCardViewModel: locationCardViewModel)
    }
}
