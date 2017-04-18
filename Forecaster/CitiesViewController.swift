//
//  CitiesViewController.swift
//  Forecaster
//
//  Created by Timothy Hang on 4/18/17.
//  Copyright © 2017 Timothy Hang. All rights reserved.
//

import UIKit
import CoreLocation

class CitiesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CitySelectorViewControllerProtocol
{
  var cities = [City]()
  var location = String()
  
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
    
//    let aCity = cities[indexPath.row]
//    cell.titleLabel.text =   aCity.title
//    cell.categoryLabel.text = aCity.category
//    
//    if aCity.done
//    {
//      cell.accessoryType = .checkmark
//    }
//    else
//    {
//      cell.accessoryType = .none
//    }
    
    return cell
  }
  
  // MARK: - Table view delegate
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
  {
    //    tableView.cellForRow(at: indexPath)?.accessoryType = .none
//    tableView.deselectRow(at: indexPath, animated: true)
    
//    if let selectedCell = tableView.cellForRow(at: indexPath)
//    {
//      let selectedCity = cities[indexPath.row]
//    
//      let geocoder = CLGeocoder()
//      geocoder.geocodeAddressString(location, completionHandler: {
//        placemarks, error in
//        if let geocodeError = error
//        {
//          print(geocodeError.localizedDescription)
//        }
//      })
//    }
  }
  
  func cityAdded(location: String)
  {
    self.location = location
    
  }
}

struct City
{
  var locationLatitude = Double()
  var locationLongitude = Double()
  
  init(latitude: Double, longitude: Double)
  {
    self.locationLatitude = latitude
    self.locationLongitude = longitude
  }
}

extension CitiesViewController              // MARK: - save functions
{
//  func saveCities()
//  {
//    let cityData = NSKeyedArchiver.archivedData(withRootObject: cities)
//    let defaults = UserDefaults.standard        //singleton -> one  unique object(standard object)
    //    defaults.set(CityData, forKey: kCitiesKey)
    //    defaults.synchronize()
    //  }
    //
    //  func loadCities()
    //  {
    //    if cities.count == 0
    //    {
    //      let defaults = UserDefaults.standard
    //      if let CityData = defaults.object(forKey: kCitiesKey) as? Data
    //      {
    //        if let savedCities = NSKeyedUnarchiver.unarchiveObject(with: CityData) as? [CityCD]
    //        {
    //          cities = savedCities
    //          tableView.reloadData()
    //        }
    //      }
    //    }
//  }
}








