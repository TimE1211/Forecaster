//
//  LocationManager.swift
//  Forecaster
//
//  Created by Timothy Hang on 4/18/17.
//  Copyright © 2017 Timothy Hang. All rights reserved.
//

import Foundation
import CoreLocation

class LocationManager
{
  var locationLatitude = Double()
  var locationLongitude = Double()
  let locationManager = CLLocationManager()
  
  func loadCurrentLocation()
  {
    configureLocationManager()
  }
  
  func configureLocationManager()
  {
    if CLLocationManager.authorizationStatus() != CLAuthorizationStatus.denied && CLLocationManager.authorizationStatus() != CLAuthorizationStatus.restricted
    {
      locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
      if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.notDetermined
      {
        locationManager.requestWhenInUseAuthorization()
      }
    }
  }
  
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus)
  {
    if status == CLAuthorizationStatus.authorizedWhenInUse
    {
      locationManager.startUpdatingLocation()
    }
  }
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
  {
    locationManager.stopUpdatingLocation()
    if let location = locations.last
    {
      locationLatitude = location.coordinate.latitude
      locationLongitude = location.coordinate.longitude
    }
  }
}
