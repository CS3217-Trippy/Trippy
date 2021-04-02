//
//  WeatherSection.swift
//  Trippy
//
//  Created by Fidella Widjojo on 30/3/21.
//

import Foundation
import CoreLocation

class WeatherSectionViewModel: ObservableObject {
    let BASE_ICON_URL = "http://openweathermap.org/img/wn/"
    var coordinates: CLLocationCoordinate2D
    @Published var title: String = ""
    @Published var description: String = ""
    @Published var temperature: Double = 0.0
    @Published var humidity: Int = 0
    @Published var cloudiness: Int = 0
    @Published var windSpeed: Double = 0.0
    @Published  var iconUrl: String = ""

    init(coordinates: CLLocationCoordinate2D) {
        self.coordinates = coordinates
        WeatherService.shared.getWeather(coordinates: coordinates, completionHandler: { result in
            switch result {
            case .success(let data):
                print(data)
                self.title = data.weather[0].main
                self.description = data.weather[0].description
                self.iconUrl = self.BASE_ICON_URL + data.weather[0].icon + "@2x.png"
                self.temperature = data.main.temp
                self.humidity = data.main.humidity
                self.cloudiness = data.clouds.all
                self.windSpeed = data.wind.speed
            case .failure(let error):
                print(error)
            }
        })
    }
}
