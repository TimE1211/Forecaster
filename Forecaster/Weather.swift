//
//  Weather.swift
//  Forecaster
//
//  Created by Timothy Hang on 4/5/17.
//  Copyright © 2017 Timothy Hang. All rights reserved.
//

import Foundation


struct Weather
{
//  let DarkSkyURL = "https://api.darksky.net/forecast/61c89a172b4204bb03af10e2342671cd/37.8267,-122.4233"
  
  let summary: String
  let precipProbability: Double
  let precipIntensity: Double
  let temperature: Double
  let humidity: Double
  let windSpeed: Double
  
  init(dictionary: [String: Any]) {
    self.summary = dictionary["summary"] as! String
  }
  
  init(summary: String, precipProbability: Double, precipIntensity: Double, temperature: Double, humidity: Double, windSpeed: Double)
  {
    self.summary = summary
    self.precipProbability = precipProbability
    self.precipIntensity = precipIntensity
    self.temperature = temperature
    self.humidity = humidity
    self.windSpeed = windSpeed
  }
  
  static func weathersWith(json attributes: [Any]) -> [Weather]
  {
    var weatherAttributes = [Weather]()
    
    if attributes.count > 0
    {
      for attribute in attributes
      {
        if let dictionary = attribute as? [String: Any]
        {
          let summary = dictionary["summary"] as? String
          let precipProbability = dictionary["precipProbability"] as? Double ?? 0
          let precipIntensity = dictionary["precipIntensity"] as? Double ?? 0
          let temperature = dictionary["temperature"] as? Double ?? 0
          let humidity = dictionary["humidity"] as? Double ?? 0
          let windSpeed = dictionary["windSpeed"] as? Double ?? 0
          
          let aWeatherAttribute = Weather(summary: summary!, precipProbability: precipProbability, precipIntensity: precipIntensity, temperature: temperature, humidity: humidity, windSpeed: windSpeed)
          weatherAttributes.append(aWeatherAttribute)
        }
      }
    }
    return weatherAttributes
  }
}
