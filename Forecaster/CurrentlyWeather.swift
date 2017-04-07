//
//  Weather.swift
//  Forecaster
//
//  Created by Timothy Hang on 4/5/17.
//  Copyright © 2017 Timothy Hang. All rights reserved.
//

import Foundation

class CurrentlyWeather
{
  
  var summary: String
  var precipProbability: Double
  var temperature: Double
  var humidity: Double
  var windSpeed: Double
  var cloudCover: Double
  
  init(currentlyDictionary: [String: Any])
  {
    summary = currentlyDictionary["icon"] as? String ?? ""
    precipProbability = currentlyDictionary["precipProbability"] as! Double
    temperature = currentlyDictionary["temperature"] as! Double
    humidity = currentlyDictionary["humidity"] as! Double
    windSpeed = currentlyDictionary["windSpeed"] as! Double
    cloudCover = currentlyDictionary["cloudCover"] as! Double
  }
}
