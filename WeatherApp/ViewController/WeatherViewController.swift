//
//  WeatherViewController.swift
//  WeatherApp
//
//  Created by Reshma Unnikrishnan on 21.08.19.
//  Copyright © 2019 ruvlmoon. All rights reserved.
//

import UIKit
import CoreLocation

extension Date {
    var hour: Int { return Calendar.current.component(.hour, from: self) } // get hour only from Date
}

protocol ChangeCityDelegate {
    func location(city : String)
}

class WeatherViewController: UIViewController, ChangeCityDelegate {
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var changeCityButton: UIButton!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var minTemperatureValue: UILabel!
    @IBOutlet weak var maxTemperatureValue: UILabel!
    @IBOutlet weak var temperature: UILabel!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var windValue: UILabel!
    @IBOutlet weak var animationContainer: UIView!
    
    var viewModel : WeatherViewModel = WeatherViewModel()
    
    init(viewModel: WeatherViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func location(city: String) {
        viewModel.getWeatherResults(city: city)
    }
    
    // MARK: - Public Properties
    
    let locationManager = CLLocationManager()


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.addLocationDelegate()
        self.initBinding()
    }

    private func initBinding() {
        self.viewModel.weather.valueChanged = { [weak self] weather in
            guard let thisSelf = self else{
                return
            }
            thisSelf.cityLabel.text = weather?.name
            thisSelf.descriptionLabel.text = weather?.weather?[0].description
            thisSelf.minTemperatureValue.text = thisSelf.temperatureInCelsius(weather?.main?.temp_min ?? 0)
            thisSelf.maxTemperatureValue.text = thisSelf.temperatureInCelsius(weather?.main?.temp_max ?? 0)
            thisSelf.temperature.text = thisSelf.temperatureInCelsius(weather?.main?.temp ?? 0)
            thisSelf.windValue.text = "\(weather?.wind?.speed ?? 0)"
            
            thisSelf.icon.animateImagesUrls(urls: thisSelf.viewModel.iconUrlsForWeather())
            
        }
        
        self.viewModel.weatherError.valueChanged = { [weak self] error in
            if let error = error {
                switch(error) {
                case .invalidUrl,
                     .noData,
                     .parseDataError:
                    let alert = UIAlertController(title: "We have hit an issue", message: "Please try again.", preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    
                    self?.present(alert, animated: true)
                    
                case .notFound:
                    let alert = UIAlertController(title: "City not found", message: "We could not find the city you searched for. Try something else.", preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    
                    self?.present(alert, animated: true)
                }
            }
        }
    }

    func temperatureInCelsius(_ val: Double) -> String {
        let temperature = Int(val - 273)
        return "\((temperature)) ℃"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "chooseCityName" {
            let destinationVC = segue.destination as! ChooseCityViewController
            destinationVC.changedCityDelegate = self
        }
    }
}

extension WeatherViewController : CLLocationManagerDelegate {
    
    func addLocationDelegate() {
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.distanceFilter = kCLDistanceFilterNone;
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last! as CLLocation
        print(location)
        viewModel.getWeatherResults(location: location)
    }
    
    func locationManager(_ manager: CLLocationManager, didFinishDeferredUpdatesWithError error: Error?) {
        viewModel.getWeatherResults(city: "Berlin")
    }
    
    //Write the didFailWithError method here:
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        cityLabel.text = "Could not get location"
    }    
}
