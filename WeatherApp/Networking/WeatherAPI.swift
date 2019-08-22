//
//  WeatherAPI.swift
//  WeatherApp
//
//  Created by Reshma Unnikrishnan on 21.08.19.
//  Copyright © 2019 ruvlmoon. All rights reserved.
//

import Foundation

let apiKey: String = "d263da55e55955c2b23d43e2bb2b0b20"

/// API endpoints
public enum WeatherAPI  {
    case currentWeatherInCity(_ city: String)
    case currentLocationWeatherIn( lat: Double, lon: Double)
    case hourlyWeatherInCity(_ city: String)
}

/// End point types
public protocol EndpointType {
    var url: URL? { get }
}

/// End point types
extension WeatherAPI: EndpointType {
    public var url: URL? {
        var components = URLComponents()
        
        components.scheme = "https"
        components.host = "api.openweathermap.org"
        
        switch self {
        case .currentWeatherInCity(let cityName):
            let queryItemQ = URLQueryItem(name: "q", value: cityName)
            let queryItemappID = URLQueryItem(name: "appid", value: apiKey)
            
            components.queryItems = [queryItemQ, queryItemappID]
            components.path = "/data/2.5/weather"
            
            return components.url
            
        case  .hourlyWeatherInCity(let cityName):
            let queryItemID = URLQueryItem(name: "id", value: cityName)
            let queryItemappID = URLQueryItem(name: "appid", value: apiKey)
            
            components.queryItems = [queryItemID, queryItemappID]
            components.path = "/data/2.5/hourly"
            
            return components.url
            
        case  .currentLocationWeatherIn(lat: let latitude, lon: let longitude):
            let queryItemLat = URLQueryItem(name: "lat", value: latitude.description)
            let queryItemLon = URLQueryItem(name: "lon", value: longitude.description)
            let queryItemappID = URLQueryItem(name: "appid", value: apiKey)
            
            components.queryItems = [queryItemLat, queryItemLon, queryItemappID]
            components.path = "/data/2.5/weather"
            
            return components.url
        }
    }
}

