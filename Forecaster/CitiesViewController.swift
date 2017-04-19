//
//  CitiesViewController.swift
//  Forecaster
//
//  Created by Timothy Hang on 4/18/17.
//  Copyright © 2017 Timothy Hang. All rights reserved.
//

import UIKit
import CoreLocation

protocol CitiesViewControllerProtocol
{
  func citiesViewControllerDidSend(latitude: Double, longitude: Double, name: String)
}

class CitiesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CitySelectorViewControllerProtocol
{
  var cities = [City]()
  var delegate: APIControllerProtocol!
  
  init(delegate: APIControllerProtocol)
  {
    self.delegate = delegate
  }

  
  override func viewDidLoad()
  {
    super.viewDidLoad()
  }
  
  override func didReceiveMemoryWarning()
  {
    super.didReceiveMemoryWarning()
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
  {
    return cities.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
  {
    let cell = tableView.dequeueReusableCell(withIdentifier: "CityCell", for: indexPath) as! CityCell
    
    let aCity = cities[indexPath.row]
    cell.cityNameLabel.text = aCity.cityName
    
    return cell
  }
  
  // MARK: - Table view delegate
  
  func cityAdded(location: String)
  {
    cityNameOrZipLocation(location: location)
  }
  
  func cityNameOrZipLocation(location: String)
  {
    let geocoder = CLGeocoder()
    geocoder.geocodeAddressString(location, completionHandler: {
      placemarks, error in
      if let geocodeError = error
      {
        print(geocodeError.localizedDescription)
      }
      else
      {
        if let placemark = placemarks?[0]
        {
          let locationCoordinates = (placemark.location?.coordinate)!
          let cityLatitude = locationCoordinates.latitude
          let cityLongitude = locationCoordinates.longitude
          let cityName = (placemark.name)
          let aCity = City(latitude: cityLatitude, longitude: cityLongitude, name: cityName!)
          self.cities.append(aCity)
        }
      }
    })
  }
}

struct City
{
  var locationLatitude = Double()
  var locationLongitude = Double()
  var cityName = String()
  
  init(latitude: Double, longitude: Double, name: String)
  {
    self.locationLatitude = latitude
    self.locationLongitude = longitude
    self.cityName = name
  }
}

extension CitiesViewController              // MARK: - save functions
{
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
  {
    tableView.deselectRow(at: indexPath, animated: true)
    
    let selectedCity = cities[indexPath.row]
    if selectedCity.cityName != ""
    {
      delegate.citiesViewControllerDidSend(latitude: selectedCity.locationLatitude, longitude: selectedCity.locationLongitude, name: selectedCity.cityName)
    }
  }
  
  func saveCities()
  {
//    let cityData = NSKeyedArchiver.archivedData(withRootObject: cities)
//    let defaults = UserDefaults.standard
//        defaults.set(cityData, forKey: kCitiesKey)
//        defaults.synchronize()
//      }
//    
//      func loadCities()
//      {
//        if cities.count == 0
//        {
//          let defaults = UserDefaults.standard
//          if let CityData = defaults.object(forKey: kCitiesKey) as? Data
//          {
//            if let savedCities = NSKeyedUnarchiver.unarchiveObject(with: CityData) as? [CityCD]
//            {
//              cities = savedCities
//              tableView.reloadData()
//            }
//          }
//        }
//  }
}








