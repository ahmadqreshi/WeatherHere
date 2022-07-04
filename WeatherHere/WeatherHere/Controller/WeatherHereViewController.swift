//
//  ViewController.swift
//  WeatherHere
//
//  Created by Admin on 27/03/22.
//

import UIKit
import CoreLocation

class WeatherHereViewController: UIViewController {

    //MARK: - OUtlets
    @IBOutlet weak private var searchTextField: UITextField!
    @IBOutlet weak private var conditionImageView: UIImageView!
    @IBOutlet weak private var temperatureLabel: UILabel!
    @IBOutlet weak private var cityLabel: UILabel!
    @IBOutlet weak private var feelsLikeLabel: UILabel!
    @IBOutlet weak private var weatherDescriptionLabel: UILabel!
    
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        weatherManager.delagate = self
        searchTextField.delegate = self
    }
    @IBAction func getLocationPressed(_ sender: UIButton) {
        locationManager.requestLocation()
    }
}

//MARK: - TextField Delegates
extension WeatherHereViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        return true
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if searchTextField.text != nil{
            return true
        }else{
            searchTextField.placeholder = "Type Something!"
            return false
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let cityName = searchTextField.text{
            weatherManager.fetchWeather(cityName)
        }
        searchTextField.text = nil
    }
    
    @IBAction func searchBtnPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
    }
}

//MARK: - WeatherManager Delegates
extension WeatherHereViewController : WeatherManagerDelegate {
    func passDataToViewController(_ weatherManager : WeatherManager, weather: WeatherModel) {
        DispatchQueue.main.async {
            self.conditionImageView.image = UIImage(systemName: weather.conditionImage)
            self.temperatureLabel.text = weather.temperatureString
            self.cityLabel.text = weather.cityName
            self.feelsLikeLabel.text = "Feels like  \(weather.weatherFeelsLikeString) °C"
            self.weatherDescriptionLabel.text = weather.weatherDesc
        }
    }
    func didFailWithError(error: Error) {
        print(error)
    }
}

//MARK: - CLLocationManagerDelegate

extension WeatherHereViewController : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.fetchWeather(latitude : lat , longitude : lon)
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
