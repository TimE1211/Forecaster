//
//  City.swift
//  Forecaster
//
//  Created by Timothy Hang on 6/15/17.
//  Copyright © 2017 Timothy Hang. All rights reserved.
//

import Foundation

class City
{
  static var current: City!
  
  var latitude: Double
  var longitude: Double
  var name: String
  
  init(latitude: Double, longitude: Double, name: String)
  {
    self.latitude = latitude
    self.longitude = longitude
    self.name = name
  }
}
