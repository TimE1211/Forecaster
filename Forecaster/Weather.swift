//
//  Weather.swift
//  Forecaster
//
//  Created by Timothy Hang on 4/5/17.
//  Copyright © 2017 Timothy Hang. All rights reserved.
//

import Foundation

class Weather
{
//  let DarkSkyURL = "https://api.darksky.net/forecast/61c89a172b4204bb03af10e2342671cd/37.8267,-122.4233"
  
  let summary: String
  let precipProbability: Double
  let precipIntensity: Double
  let temperature: Double
  let humidity: Double
  let windSpeed: Double
  let cloudCover: Double
  
  init(weatherDictionary: [String: Any])
  {
    summary = weatherDictionary["summary"] as? String ?? ""
    precipProbability = weatherDictionary["precipProbability"] as! Double
    precipIntensity = weatherDictionary["precipIntensity"] as! Double
    temperature = weatherDictionary["temperature"] as! Double
    humidity = weatherDictionary["humidity"] as! Double
    windSpeed = weatherDictionary["windSpeed"] as! Double
    cloudCover = weatherDictionary[""]
  }
  
  static func weatherWithDictionary(weatherDict: [String: Any]) -> Weather
  {
    return Weather(weatherDictionary: weatherDict)
  }
}
