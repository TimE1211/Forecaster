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
  var locationName = String()
  
  let locationManager = CLLocationManager()
  
  var delegate: LocationManagerDelegate!
  
  init(delegate: LocationManagerDelegate)
  {
    self.delegate = delegate
  }
  
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
      City.current = City(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude, name: "Current Location")
      
      search //api for weather info on this location in forecaster when we get current location info
    }
  }
}


