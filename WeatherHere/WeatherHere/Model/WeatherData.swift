//
//  WeatherData.swift
//  WeatherHere
//
//  Created by Admin on 28/03/22.
//

import Foundation

struct WeatherData : Decodable {
    let name : String
    let main : Main
    let weather : [Weather]
}

struct Main : Decodable {
    let temp : Double
    let feels_like : Double
}

struct Weather : Decodable {
    let id : Int
    let description : String
}
