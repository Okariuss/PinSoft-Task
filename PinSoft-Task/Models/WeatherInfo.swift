//
//  WeatherInfo.swift
//  PinSoft-Task
//
//  Created by Okan Orkun on 29.02.2024.
//

import Foundation

struct WeatherInfo: Codable {
    let id: Int
    let city, country: String
    let latitude, longitude: Double
    let temperature: Double
    let weatherDescription: WeatherCondition
    let humidity: Int
    let windSpeed: Double
    let forecast: [Forecast]

    enum CodingKeys: String, CodingKey {
        case id, city, country, latitude, longitude, temperature, humidity, forecast
        case weatherDescription = "weather_description"
        case windSpeed = "wind_speed"
    }
}

struct Forecast: Codable {
    let date: String
    let temperature: Double
    let weatherDescription: String
    let humidity, windSpeed: Double

    enum CodingKeys: String, CodingKey {
        case date, temperature, humidity
        case weatherDescription = "weather_description"
        case windSpeed = "wind_speed"
    }
}

enum WeatherCondition: String, Codable {
    case clearSky = "clear sky"
    case partlyCloudy = "partly cloudy"
    case cloudy
    case sunny
    case rainShowers = "rain showers"
    case rain
    case rainy
    case scatteredClouds = "scattered clouds"
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawValue = try container.decode(String.self).lowercased()
        switch rawValue {
        case "clear sky":
            self = .clearSky
        case "partly cloudy":
            self = .partlyCloudy
        case "cloudy":
            self = .cloudy
        case "sunny":
            self = .sunny
        case "rain showers":
            self = .rainShowers
        case "rain", "rainy":
            self = .rain
        case "scattered clouds":
            self = .scatteredClouds
        default:
            self = .cloudy
        }
    }
}

typealias WeatherData = [WeatherInfo]
