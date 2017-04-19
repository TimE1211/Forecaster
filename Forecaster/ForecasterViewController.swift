//
//  ViewController.swift
//  Forecaster
//
//  Created by Timothy Hang on 4/5/17.
//  Copyright © 2017 Timothy Hang. All rights reserved.
//

import UIKit
import CoreLocation

class ForecasterViewController: UIViewController, APIControllerProtocol//, CLLocationManagerDelegate
{
  var apiController: APIController!
  var locationManager: LocationManager!
  
  let formatter = DateFormatter()
  let today = Date()
  var locationLatitude = Double()
  var locationLongitude = Double()
  
  var dailyWeather = [DailyWeather]()
  
  @IBOutlet weak var precipProbabilityLabel: UILabel!
  @IBOutlet weak var windSpeedLabel: UILabel!
  @IBOutlet weak var temperatureLabel: UILabel!
  @IBOutlet weak var cloudCoverLabel: UILabel!
  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var hatLabel: UILabel!
  @IBOutlet weak var umbrellaLabel: UILabel!
  @IBOutlet weak var minTempLabel: UILabel!
  @IBOutlet weak var maxTempLabel: UILabel!
  
  override func viewDidLoad()
  {
    super.viewDidLoad()
    let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
    backgroundImage.image = UIImage(named: "colourback_9006.jpg")
    self.view.insertSubview(backgroundImage, at: 0)
//    http://stackoverflow.com/questions/27049937/how-to-set-a-background-image-in-xcode-using-swift
//    http://wallpaperswide.com/rainy_weather-wallpapers.html = images.jpeg url
//    http://www.zrarts.com/Websites-for-Background-Colors/ = colourback_9006.jpg url
    formatter.dateFormat = "EEE, MMM dd "
    dateLabel.text = formatter.string(from: today)
    temperatureLabel.text = ""
    hatLabel.text = ""
    umbrellaLabel.text = ""
    cloudCoverLabel.text = ""
    precipProbabilityLabel.text = ""
    windSpeedLabel.text = ""
    minTempLabel.text = ""
    maxTempLabel.text = ""
    
    if let label = temperatureLabel
    {
      label.layer.cornerRadius = label.frame.width/2
      label.layer.borderColor = UIColor.gray.cgColor
      label.layer.borderWidth = 5.0
      label.layer.backgroundColor = UIColor.white.cgColor
    }
    
    apiController = APIController(delegate: self)
    locationManager = LocationManager(delegate: self)
    
    locationManager.loadCurrentLocation()
  }
  
  override func viewWillAppear(_ animated: Bool)
  {
    super.viewWillAppear(animated)
    apiController.searchDarkSkyFor(latitude: "\(locationLatitude)", longitude: "\(locationLongitude)")
    hideWeatherViewsInPreparationForAnimation()
  }

  override func didReceiveMemoryWarning()
  {
    super.didReceiveMemoryWarning()
  }

  func apiControllerDidSend(results1: [String : Any], results2: [String: Any])      // protocol function receiving info below
  {
    let dailyDataArray = results2["data"] as! [Any]
    let todaysData = dailyDataArray[0] as! [String: Any]
    let currentWeather = CurrentlyWeather(currentlyDictionary: results1)    //Weather object with the "currently" key value dictionary
    let todaysWeather = DailyWeather(dailyDictionary: todaysData)
    
    self.reloadViewCurrently(with: currentWeather)
    self.reloadViewDaily(with: todaysWeather)
    animateWeatherViews()
    
    for dailyData in dailyDataArray
    {
      let datesWeather = DailyWeather(dailyDictionary: dailyData as! [String: Any])
      dailyWeather.append(datesWeather)
    }
  }
  
  func reloadViewDaily(with weather: DailyWeather)
  {
    minTempLabel.text = String(Int(weather.temperatureMin)) + "º"
    maxTempLabel.text = String(Int(weather.temperatureMax)) + "º"
  }
  
  func reloadViewCurrently(with weather: CurrentlyWeather)
  {
    //precipitation type
    var precipType = String()
    
    if weather.icon == "snow" || weather.icon == "sleet"
    {
      precipType = "❄️"
    }
    else
    {
      precipType = "💧"
    }
    
    windSpeedLabel.text = String(weather.windSpeed) + "mph🌬"
    temperatureLabel.text = " " + String(Int(weather.temperature)) + "º"
    precipProbabilityLabel.text = String(Int((weather.precipProbability)*100)) + "%\(precipType)"
    
    if weather.precipProbability > 0.8
    {
      umbrellaLabel.text = "⛱"
    }
    else
    {
      umbrellaLabel.text = ""
    }
    
    if weather.windSpeed >= 10
    {
      hatLabel.text = "💂"
    }
    else
    {
      hatLabel.text = ""
    }
    
    if weather.cloudCover < 0.25 && weather.precipProbability < 1
    {
      cloudCoverLabel.text = "☀️"
    }
    else if weather.cloudCover < 0.25 && weather.precipProbability == 1
    {
      cloudCoverLabel.text = "☀️\(precipType)"
    }
    else if weather.cloudCover >= 0.25 && weather.cloudCover <= 0.75 && weather.precipProbability < 1
    {
      cloudCoverLabel.text = "🌤"
    }
    else if weather.cloudCover > 0.75 && weather.precipProbability < 1
    {
      cloudCoverLabel.text = "☁️"
    }
    else if weather.cloudCover >= 0.25 && weather.cloudCover <= 0.75 && weather.precipProbability == 1
    {
      cloudCoverLabel.text = "🌦\(precipType)"
    }
    else if weather.cloudCover > 0.75 && weather.precipProbability == 1
    {
      cloudCoverLabel.text = "🌧\(precipType)"
    }
    else
    {
      cloudCoverLabel.text = ""
    }
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?)
  {
    if segue.identifier == "WeeklyForecastSegue"
    {
      let dailyTVC = segue.destination as! DailyWeatherTableViewController
      dailyTVC.dailyWeather = dailyWeather
    }
  }
}

extension ForecasterViewController: LocationManagerDelegate
{
  func locationManager(manager: LocationManager, didUpdateLocationWith latitude: Double, and longitude: Double) {
    self.locationLatitude = locationManager.locationLatitude
    self.locationLongitude = locationManager.locationLongitude
    print("\(locationLatitude) + \(locationLongitude)")
  }
}

extension ForecasterViewController      //location functions
{
//
//  func loadCurrentLocation()
//  {
//    configureLocationManager()
//  }
//  
//  func configureLocationManager()
//  {
//    if CLLocationManager.authorizationStatus() != CLAuthorizationStatus.denied && CLLocationManager.authorizationStatus() != CLAuthorizationStatus.restricted
//    {
//      locationManager.delegate = self
//      locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
//      if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.notDetermined
//      {
//        locationManager.requestWhenInUseAuthorization()
//      }
//    }
//  }
//  
//  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus)
//  {
//    if status == CLAuthorizationStatus.authorizedWhenInUse
//    {
//      locationManager.startUpdatingLocation()
//    }
//  }
//  
//  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
//  {
//    locationManager.stopUpdatingLocation()
//    if let location = locations.last
//    {
//      locationLatitude = location.coordinate.latitude
//      locationLongitude = location.coordinate.longitude
//    }
//  }
//  // end of location functions ... could probably move location functions to api to decrease bloat
}

extension ForecasterViewController                //david and I worked together on animations
{
  func hideWeatherViewsInPreparationForAnimation()
  {
    temperatureLabel.alpha = 0
  }
  
  func animateWeatherViews()
  {
    let labels = [temperatureLabel!, windSpeedLabel!, hatLabel!, umbrellaLabel!, maxTempLabel!, minTempLabel!, cloudCoverLabel!, windSpeedLabel!, precipProbabilityLabel!]
    let originalOriginYs = labels.map
    {
      label in
      label.frame.origin.y
    }
    
    for label in labels
    {
      label.frame.origin.y = view.frame.height
    }
    
    UIView.animate(withDuration: 0.5, animations:
    {
      
      var count = 0
      for label in labels
      {
        label.alpha = 1
        label.frame.origin.y = originalOriginYs[count]
        
        count += 1
      }
    }, completion: { finished in
      UIView.animate(withDuration: 0.25, animations:
      {
        self.temperatureLabel.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
      }, completion: { finished in
        self.temperatureLabel.transform = .identity
      })
    })
  }
}











