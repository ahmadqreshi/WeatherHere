//
//  WeatherManager.swift
//  WeatherHere
//
//  Created by Admin on 28/03/22.
//

import Foundation
import CoreLocation


protocol WeatherManagerDelegate : AnyObject {  // adopted the delegate design pattern
    func passDataToViewController(_ weatherManager : WeatherManager, weather: WeatherModel)
    func didFailWithError(error : Error)
}

struct WeatherManager {
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=812686cf4734439697aab63d028f40f9&units=metric"
    
    weak var delagate : WeatherManagerDelegate?
    
    func fetchWeather(_ cityName : String) {
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(urlString: urlString)
    }
    
    //Networking -> app makes request to web server by using API
    func fetchWeather(latitude : CLLocationDegrees, longitude : CLLocationDegrees) {
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        performRequest(urlString: urlString)
    }
    func performRequest(urlString : String) {
        //1. Create a URL
        
        if let url = URL(string: urlString) {
            //2. Create a URLSession
            let session = URLSession(configuration: .default)
            
            //3. Give the session a task
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil{
                    delagate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
//                    let dataString = String(data: safeData, encoding: .utf8)
//                    print(dataString ?? "not working")
                    if let weather =  self.parseJSON(weatherData: safeData) {
                        delagate?.passDataToViewController(self, weather: weather)
                    }
                }
            }
            
            //4. Start the task
            task.resume()
        }
    }
    func parseJSON(weatherData : Data) -> WeatherModel?{
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let weatherId = decodedData.weather[0].id
            let cityName = decodedData.name
            let cityTemp = decodedData.main.temp
            let weatherDesc = decodedData.weather[0].description
            let weatherFeelsLike = decodedData.main.feels_like
            
            let weatherModel = WeatherModel(weatherId: weatherId, cityName: cityName, cityTemp: cityTemp, weatherDesc: weatherDesc, weatherFeelsLike: weatherFeelsLike)
            return weatherModel
        } catch{
            self.delagate?.didFailWithError(error: error)
            return nil
        }
    }
    
}
