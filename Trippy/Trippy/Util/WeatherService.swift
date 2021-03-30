//
//  WeatherService.swift
//  Trippy
//
//  Created by Fidella Widjojo on 30/3/21.
//

import CoreLocation

final class WeatherService {
    static let shared = WeatherService()

    let BASE_URL = "http://api.openweathermap.org/data/2.5/weather?"
    let API_KEY = "4b3ac8ff3507910068ad05baff25cfe5"
    let session = URLSession(configuration: .default)

    func buildUrl(coordinates: CLLocationCoordinate2D) -> String {
        let queries = "lat=" + coordinates.latitude.description +
            "&lon=" + coordinates.longitude.description + "&appid=" + API_KEY + "&units=metric"
        return BASE_URL + queries
    }

    func getWeather(coordinates: CLLocationCoordinate2D,
                    completionHandler: @escaping (Result<CurrentWeather, Error>) -> Void) {
        guard let url = URL(string: buildUrl(coordinates: coordinates)) else {
            completionHandler(.failure(NetworkError.invalidURL))
            return
        }

        let task = session.dataTask(with: url) { data, response, error in

                    DispatchQueue.main.async {
                        if let error = error {
                            completionHandler(.failure(error))
                            return
                        }

                        guard let data = data, let response = response as? HTTPURLResponse else {
                            completionHandler(.failure(NetworkError.invalidResponse))
                            return
                        }

                        do {
                            if response.statusCode == 200 {
                                let items = try JSONDecoder().decode(CurrentWeather.self, from: data)
                                completionHandler(.success(items))
                            } else {
                                completionHandler(.failure(NetworkError.invalidResponse))
                            }
                        } catch {
                            completionHandler(.failure(error))
                        }
                    }

        }
                task.resume()
    }

}
