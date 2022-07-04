//
//  WeatherModel.swift
//  WeatherHere
//
//  Created by Admin on 28/03/22.
//

import Foundation

struct WeatherModel {
    let weatherId : Int
    let cityName : String
    let cityTemp : Double
    let weatherDesc : String
    let weatherFeelsLike : Double
    var conditionImage : String {
        switch weatherId {
        case 200...232 :
            return "cloud.bolt"
        case 300...321 :
            return "cloud.drizzle"
        case 500...531 :
            return "cloud rain"
        case 600...622 :
            return "cloud.snow"
        case 701...781 :
            return "cloud.fog"
        case 800 :
            return "sun.max"
        case 801...804 :
            return "cloud.bolt"
        default:
            return "cloud"
        }
    }
    var temperatureString : String {
        return String(format: "%.1f", cityTemp)
    }
    
    var weatherFeelsLikeString : String {
        return String(format: "%.1f", weatherFeelsLike)
    }
}
