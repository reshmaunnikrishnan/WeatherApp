//
//  NetworkServiceTests.swift
//  WeatherAppTests
//
//  Created by Reshma Unnikrishnan on 21.08.19.
//  Copyright © 2019 ruvlmoon. All rights reserved.
//

import XCTest
@testable import WeatherApp

class NetworkServiceTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    
    func testGetWeatherWithExpectedURLHostAndPath() {
        let networkService : NetworkService! = NetworkService()
        let data: Data = Data()

        let mockSession = MockURLSession(data: data, urlResponse: nil, error: nil)
        networkService.session = mockSession
        networkService.performNetworkTask(endpoint: WeatherAPI.currentWeatherInCity("Berlin"), completion: {results in
            
        
        }, onError: {error  in})
        
        XCTAssertEqual(mockSession.cachedUrl?.path, "/data/2.5/weather")
        XCTAssertEqual(mockSession.cachedUrl?.host, "api.openweathermap.org")

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
    
    func testGetMoviesSuccessReturnsWeather() {
        let networkService : NetworkService! = NetworkService()
        let jsonData : Data = readJson()
        let mockURLSession  = MockURLSession(data: jsonData, urlResponse: nil, error: nil)
        networkService.session = mockURLSession
        
        let weatherExpectation = expectation(description: "weather")
        var weatherResponse: CurrentWeather?
        
        networkService.performNetworkTask(endpoint: WeatherAPI.currentWeatherInCity("Berlin"), completion: { (weather) in
            weatherResponse = weather
            weatherExpectation.fulfill()
        }) { _ in
        
        }
        waitForExpectations(timeout: 1) { (error) in
            XCTAssertNotNil(weatherResponse)
            XCTAssertTrue(weatherResponse?.name == "Berlin")
        }
    }
    
    func testGetMoviesWhenResponseErrorReturnsError() {
        let networkService : NetworkService! = NetworkService()
        let error = NSError(domain: "error", code: 1234, userInfo: nil)
        let mockURLSession  = MockURLSession(data: nil, urlResponse: nil, error: error)
        networkService.session = mockURLSession
        
        let errorExpectation = expectation(description: "error")
        var errorResponse: Error?
        networkService.performNetworkTask(endpoint: WeatherAPI.currentWeatherInCity("Berlin"), completion: { _ in
        }) { error in
            errorResponse = error
            errorExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 1) { (error) in
            XCTAssertNotNil(errorResponse)
        }
    }
    
}

class MockURLSession: URLSession {
    private let mockTask: MockTask
    var cachedUrl: URL?
    init(data: Data?, urlResponse: URLResponse?, error: Error?) {
        mockTask = MockTask(data: data, urlResponse: urlResponse, networkError:
            error)
    }
    override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        self.cachedUrl = url
        mockTask.completionHandler = completionHandler
        return mockTask
    }
}

class MockTask: URLSessionDataTask {
    private let data: Data?
    private let urlResponse: URLResponse?
    private let networkError: Error?
    
    var completionHandler: ((Data?, URLResponse?, Error?) -> Void)!
    init(data: Data?, urlResponse: URLResponse?, networkError: Error?) {
        self.data = data
        self.urlResponse = urlResponse
        self.networkError = networkError
    }
    override func resume() {
        DispatchQueue.main.async {
            self.completionHandler(self.data, self.urlResponse, self.networkError)
        }
    }
}

