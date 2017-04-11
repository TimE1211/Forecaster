//
//  File.swift
//  Forecaster
//
//  Created by Timothy Hang on 4/7/17.
//  Copyright © 2017 Timothy Hang. All rights reserved.
//

import Foundation

class DailyWeather
{
  var temperatureMax: Double
  var temperatureMin: Double
  var precipProbability: Double
  var windSpeed: Double
  var cloudCover: Double
  var icon: String
  var date: Double
  
  init(dailyDictionary: [String: Any])
  {
    temperatureMax = dailyDictionary["temperatureMax"] as! Double
    temperatureMin = dailyDictionary["temperatureMin"] as! Double
    precipProbability = dailyDictionary["precipProbability"] as! Double
    windSpeed = dailyDictionary["windSpeed"] as! Double
    icon = dailyDictionary["icon"] as? String ?? ""
    cloudCover = dailyDictionary["cloudCover"] as! Double
    date = dailyDictionary["time"] as! Double
  }
}
