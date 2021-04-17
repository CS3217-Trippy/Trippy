/**
 View of weather info of a location.
*/

import SwiftUI
import CoreLocation
import URLImage

struct WeatherSectionView: View {
    @ObservedObject var viewModel: WeatherSectionViewModel

    var body: some View {
        HStack {
            if let url = URL(string: viewModel.iconUrl) {
                URLImage(url: url) { image in
                image
                }
            }
            Text(viewModel.temperature.description + "°C")
                .font(.largeTitle)
            VStack(alignment: .leading) {
                Text("Humidity: " + viewModel.humidity.description + "%")
                Text("Cloudiness: " + viewModel.cloudiness.description + "%")
                Text("Wind speed: " + viewModel.windSpeed.description + "m/s")
            }
            Spacer()
            VStack(alignment: .trailing) {
                Text(viewModel.title)
                    .font(.title)
                Text(viewModel.description)
            }
        }
        .padding()
    }
}

struct WeatherSectionView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherSectionView(viewModel: WeatherSectionViewModel(coordinates:
                                                                CLLocationCoordinate2D(latitude: 100, longitude: 100)))
    }
}
