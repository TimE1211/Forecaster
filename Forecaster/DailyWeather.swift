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
  
init(dailyDictionary: [String: Any])
  {
    temperatureMax = dailyDictionary["temperatureMax"] as! Double
    temperatureMin = dailyDictionary["temperatureMin"] as! Double
  }
}
