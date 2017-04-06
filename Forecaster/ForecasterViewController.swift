//
//  ViewController.swift
//  Forecaster
//
//  Created by Timothy Hang on 4/5/17.
//  Copyright © 2017 Timothy Hang. All rights reserved.
//

import UIKit
import CoreLocation

class ForecasterViewController: UIViewController, APIControllerProtocol, CLLocationManagerDelegate
{
  var weatherObjects = [Weather]()
  var apiController: APIController!   //ApiController Object not made yet, need var apiController to call search url function from class ApiController
  let formatter = DateFormatter()
  let today = Date()
  var locationLatitude = Double()
  var locationLongitude = Double()
  
  let locationManager = CLLocationManager()
  
  @IBOutlet weak var precipProbabilityLabel: UILabel!
  @IBOutlet weak var windSpeedLabel: UILabel!
  @IBOutlet weak var temperatureLabel: UILabel!
  @IBOutlet weak var cloudCoverLabel: UILabel!
  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var hatLabel: UILabel!
  @IBOutlet weak var umbrellaLabel: UILabel!
  @IBOutlet weak var bootsLabel: UILabel!
  
  override func viewDidLoad()
  {
    super.viewDidLoad()
    formatter.dateFormat = "EEE, MMM dd "
    dateLabel.text = formatter.string(from: today)
    view.backgroundColor = UIColor.yellow
    temperatureLabel.text = ""
    
    loadCurrentLocation()
    
//    for label in [hatLabel, bootsLabel,umbrellaLabel, cloudCoverLabel]
//    {
//      label?.isHidden = true
//    }                                         this code is for hiding labels that arnt ready by david
    
    if let label = temperatureLabel
    {
      label.layer.cornerRadius = label.frame.width/2                                              //how to make a circle by david
      label.layer.borderColor = UIColor.black.cgColor
      label.layer.borderWidth = 5.0
      label.layer.backgroundColor = UIColor.white.cgColor
    }
    
    apiController = APIController(delegate: self)
    apiController.searchDarkSkyFor(latitude: "\(locationLatitude)", longitude: "\(locationLongitude)")
  }

  override func didReceiveMemoryWarning()
  {
    super.didReceiveMemoryWarning()
  }

  func loadCurrentLocation()
  {
    configureLocationManager()
  }
  
  func configureLocationManager()
  {
    if CLLocationManager.authorizationStatus() != CLAuthorizationStatus.denied && CLLocationManager.authorizationStatus() != CLAuthorizationStatus.restricted
    {
      locationManager.delegate = self
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
  
  // end of location functions and beginning of api and weather funcs
  
  func apiControllerDidReceive(results: [String : Any])         // protocol function receiving info below
  {
    let currentWeather = Weather(weatherDictionary: results)    //Weather object with the "currently" key value dictionary
    self.reloadView(with: currentWeather)
  }
  
  func reloadView(with weather: Weather)
  {
    windSpeedLabel.text = String(weather.windSpeed) + "kph🌬"
    precipProbabilityLabel.text = String(Int((weather.precipProbability)*100)) + "%💧"
    temperatureLabel.text = String(weather.temperature) + "º"
    cloudCoverLabel.text = String(weather.cloudCover)
    bootsLabel.text = ""
    if weather.precipProbability > 0.5
    {
      umbrellaLabel.text = "⛱"
    }
    else
    {
      umbrellaLabel.text = ""
    }
    if weather.windSpeed > 10
    {
      hatLabel.text = "💂"
    }
    else
    {
        hatLabel.text = ""
    }
    
    // clouds
    
    //cloudCoverLabel.text = 🌧⛈🌨
    if weather.cloudCover > 0.10
    {
      cloudCoverLabel.text = "☀️"
    }
    else if weather.cloudCover > 0.25
    {
      cloudCoverLabel.text = "🌤"
    }
    else if weather.cloudCover > 0.75
    {
      cloudCoverLabel.text = "☁️"
    }
    else if weather.cloudCover > 0.75 && weather.precipProbability > 0.9
    {
      cloudCoverLabel.text = "🌦"
    }
    else if weather.cloudCover > 0.99 && weather.precipProbability > 0.93
    {
      cloudCoverLabel.text = "🌦"
    }
    else
    {
      cloudCoverLabel.text = "🌧"
    }
  }
}












