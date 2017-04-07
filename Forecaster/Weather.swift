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
  
  var summary: String
  var precipProbability: Double
  var precipIntensity: Double
  var temperature: Double
  var humidity: Double
  var windSpeed: Double
  var cloudCover: Double
  
  init(weatherDictionary: [String: Any])
  {
    summary = weatherDictionary["icon"] as? String ?? ""
    precipProbability = weatherDictionary["precipProbability"] as! Double
    precipIntensity = weatherDictionary["precipIntensity"] as! Double
    temperature = weatherDictionary["temperature"] as! Double
    humidity = weatherDictionary["humidity"] as! Double
    windSpeed = weatherDictionary["windSpeed"] as! Double
    cloudCover = weatherDictionary["cloudCover"] as! Double
  }
}
