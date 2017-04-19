//
//  LocationManager.swift
//  Forecaster
//
//  Created by Timothy Hang on 4/18/17.
//  Copyright © 2017 Timothy Hang. All rights reserved.
//

import Foundation
import CoreLocation
//import MapKit

protocol LocationManagerDelegate
{
  func locationManagerDidSend(latitude: Double, name: String, longitude: Double)
}

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
      locationLatitude = location.coordinate.latitude
      locationLongitude = location.coordinate.longitude
      locationName = String(describing: location)
      
      delegate.locationManagerDidSend(latitude: locationLatitude, name: locationName, longitude: locationLongitude)
    }
  }
}


