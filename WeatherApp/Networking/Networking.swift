//
//  Networking.swift
//  WeatherApp
//
//  Created by Reshma Unnikrishnan on 21.08.19.
//  Copyright © 2019 ruvlmoon. All rights reserved.
//

import Foundation

typealias WeatherResults = (CurrentWeather) -> Void
typealias ErrorResults =  (NetworkError) -> Void

/// Response errors
public enum NetworkError: Swift.Error {
    case noData
    case invalidUrl
    case parseDataError
    case notFound
}

protocol NetworkServiceProtocol {
    
    func performNetworkTask(endpoint: WeatherAPI,  completion: @escaping WeatherResults, onError:  @escaping  ErrorResults)
    
}

class NetworkService: NetworkServiceProtocol {
    
    var session: URLSession
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    func performNetworkTask(endpoint: WeatherAPI,  completion: @escaping WeatherResults, onError:  @escaping ErrorResults) {
        
        guard let url = endpoint.url else { return }
        
        let urlSession = self.session.dataTask(with: url) { (data, urlResponse, dataError) in
            if let _ = dataError {
                onError(NetworkError.invalidUrl)
                return
            }
            
            if let httpResponse = urlResponse as? HTTPURLResponse {
                if httpResponse.statusCode == 404 {
                    onError(NetworkError.notFound)
                    return
                }
            }
            
            guard let data = data else {
                onError(NetworkError.noData)
                return
            }
            
            do {
                let decoded = try JSONDecoder().decode(CurrentWeather.self, from: data)
                
                completion(decoded)
            } catch  {
                onError(NetworkError.parseDataError)
            }
        }
        urlSession.resume()
    }
    
}
