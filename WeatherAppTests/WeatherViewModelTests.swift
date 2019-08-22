//
//  WeatherViewModelTests.swift
//  WeatherAppTests
//
//  Created by Reshma Unnikrishnan on 21.08.19.
//  Copyright © 2019 ruvlmoon. All rights reserved.
//

import XCTest
@testable import WeatherApp

class WeatherViewModelTests: XCTestCase {
    var sut: WeatherViewModel!
    var mockService: MockNetworkService! = nil

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
        mockService = MockNetworkService()
        sut = WeatherViewModel(apiService: mockService)
       
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        sut = nil
        mockService = nil
    }
    
    private func readJson() -> Data {
        guard let fileUrl = Bundle.main.url(forResource: "weather", withExtension: "json") else {
            print("File could not be located at the given url")
            return Data()
        }
        do {
            // Get data from file
            let data = try Data(contentsOf: fileUrl)
            return data
        } catch {
            // Print error if something went wrong
            print("Error: \(error)")
        }
        return Data()
    }
    
    func testWeatherItemsShouldShowWeatherDetailsWhenDataIsExisted()  {
        sut.apiService.performNetworkTask(endpoint: WeatherAPI.currentWeatherInCity("Berlin"), completion: { (weather) in
            XCTAssertNotNil(weather)
            XCTAssertTrue(weather.name == "Berlin")
        }, onError: {_ in})
    }
    
    func testWeatherItemsShouldShowErrorWhenTheLocationnNotExists()  {
        let mockService = MockNetworkErrorService()
        let sut = WeatherViewModel(apiService: mockService)
        sut.apiService.performNetworkTask(endpoint: WeatherAPI.currentWeatherInCity("ksdl"), completion: {_ in}, onError: {error in
            XCTAssertTrue(error == NetworkError.noData )
        })
    }
    
    
}


class MockNetworkService : NetworkServiceProtocol {
    func performNetworkTask(endpoint: WeatherAPI, completion: @escaping WeatherResults, onError: @escaping ErrorResults) {
        
        let results =  try! JSONDecoder().decode(CurrentWeather.self, from: readJson())
        completion(results)
    }
    
    private func readJson() -> Data {
        guard let fileUrl = Bundle.main.url(forResource: "weather", withExtension: "json") else {
            print("File could not be located at the given url")
            return Data()
        }
        do {
            // Get data from file
            let data = try Data(contentsOf: fileUrl)
            return data
        } catch {
            // Print error if something went wrong
            print("Error: \(error)")
        }
        return Data()
    }
}

class MockNetworkErrorService : NetworkServiceProtocol {
    func performNetworkTask(endpoint: WeatherAPI, completion: @escaping WeatherResults, onError: @escaping ErrorResults) {
        onError(NetworkError.noData)
    }
    
}

