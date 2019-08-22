//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by Reshma Unnikrishnan on 21.08.19.
//  Copyright © 2019 ruvlmoon. All rights reserved.
//

import Foundation
import CoreLocation

protocol WeatherViewModelDelegate {
    //informs the delegate to show an alert
    //when there is an error
    func showAlert(withMessage: String)
}

enum WeatherIcon: String {
    case thunderstorm = "thunderstorm"
    case drizzle = "light_rain"
    case rain = "shower"
    case snow = "snow"
    case atmosphere = "fog"
    case clear = "sunny"
    case clouds = "cloudy"
    case unknown = "dunno"
}


class WeatherViewModel {
    
    let alertMessage = Observable<String?>(nil)
    var cityName :String = ""
    let inputText = Observable<String?>("")
    let weather  = Observable<CurrentWeather?>(nil)
    let weatherError = Observable<NetworkError?>(nil)
    
    // MARK: - Public Properties
    let apiService: NetworkServiceProtocol
    
    init(apiService: NetworkServiceProtocol = NetworkService(session: URLSession.shared)) {
        self.apiService = apiService
    }
    
    // MARK: - Public Methods
    func getWeatherResults(city: String) {
        let endpoint = WeatherAPI.currentWeatherInCity(city)
        
        self.apiService.performNetworkTask(endpoint: endpoint, completion: { (weather) in
            self.weather.value = weather
        }) { (error) in
            self.weatherError.value = error
        }
    }
    
    func getWeatherResults(location: CLLocation) {
        let endpoint = WeatherAPI.currentLocationWeatherIn(lat: location.coordinate.latitude , lon: location.coordinate.longitude)
        
        self.apiService.performNetworkTask(endpoint: endpoint, completion: { (weather) in
            self.weather.value = weather
        }) { (error) in
            self.weatherError.value = error
        }
    }
    
    func iconUrlsForWeather() -> [URL?] {
        guard let actualWeather = weather.value?.weather else {
            let url = URL(string: "https://cdn3.iconfinder.com/data/icons/sympletts-free-sampler/128/help-questionmark-512.png")
            return [url]
        }
        
        var iconUrls: [URL?] = []
        
        actualWeather.forEach { (w) in
            if let icon = w.icon {
                let url = URL(string: "https://openweathermap.org/img/wn/\(icon)@2x.png")
                iconUrls.append(url)
            }
        }
        
        return iconUrls
    }
}
