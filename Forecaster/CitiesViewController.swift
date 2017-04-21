//
//  CitiesViewController.swift
//  Forecaster
//
//  Created by Timothy Hang on 4/18/17.
//  Copyright © 2017 Timothy Hang. All rights reserved.
//

import UIKit
import CoreLocation
import CoreData

protocol CitiesViewControllerProtocol
{
  func citiesViewControllerDidSend(latitude: Double, longitude: Double, name: String)
}

class CitiesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate
{
  var cities = [City]()
  var cityLocations = [CityLocation]()
  let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
  
  var delegate: CitiesViewControllerProtocol!
  
  @IBOutlet weak var tableView: UITableView!

  override func viewDidLoad()
  {
    super.viewDidLoad()
    navigationItem.rightBarButtonItem = editButtonItem
    
    let fetchRequest: NSFetchRequest<City> = City.fetchRequest()
    do
    {
      let fetchResults = try context.fetch(fetchRequest)
      cities = fetchResults
    }
    catch {
      let nserror = error as NSError
      NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
    }
  }

  override func didReceiveMemoryWarning()
  {
    super.didReceiveMemoryWarning()
  }
}

extension CitiesViewController          //table view functions
{
  override func setEditing(_ editing: Bool, animated: Bool)
  {
    super.setEditing(editing, animated: animated)
    tableView.setEditing(editing, animated: animated)
    
    if !editing
    {
      (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
  {
    return cities.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
  {
    let cell = tableView.dequeueReusableCell(withIdentifier: "CityCell", for: indexPath) as! CityCell
    
    let aCity = cities[indexPath.row]
    if tableView.isEditing
    {
      cell.locationTextField.isEnabled = true
    }
    else
    {
      cell.locationTextField.isEnabled = false
    }
    
    if let name = aCity.name
    {
      cell.locationTextField.text = name
    }
    else
    {
      cell.locationTextField.becomeFirstResponder()
    }
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
  {
    tableView.deselectRow(at: indexPath, animated: true)
    
    let selectedCity = cities[indexPath.row]
      delegate.citiesViewControllerDidSend(latitude: selectedCity.latitude, longitude: selectedCity.longitude, name: selectedCity.name!)
  }

  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
  {
    if editingStyle == .delete
    {
      let cityToDelete = cities[indexPath.row]
      context.delete(cityToDelete)
      cities.remove(at: indexPath.row)
      tableView.deleteRows(at: [indexPath], with: .automatic)
    }
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool
  {
    if let contentView = textField.superview,
      let cell = contentView.superview as? CityCell,
      let cityIndexPath = tableView.indexPath(for: cell)
    {
      let selectedCity = cities[cityIndexPath.row]
      if textField.text != ""
      {
        cell.locationTextField.resignFirstResponder()
//        cityNameOrZipLocation(location: textField.text!)
        
        tryGeocode(from: textField.text, completion: {
          placemarks, error in
          if let geocodeError = error
          {
            print(geocodeError.localizedDescription)
          }
          else if let placemark = placemarks?.first, let coordinate = placemark.location?.coordinate
          {
            let cityLatitude = coordinate.latitude
            let cityLongitude = coordinate.longitude
            let cityName = placemark.name ?? ""
            let aCityLocation = CityLocation(latitude: cityLatitude, longitude: cityLongitude, name: cityName)
            
            self.cityLocations.append(aCityLocation)
            
            let selectedCityLocation = self.cityLocations[cityIndexPath.row]
            selectedCity.latitude = selectedCityLocation.latitude
            selectedCity.longitude = selectedCityLocation.longitude
            selectedCity.name = selectedCityLocation.name
          }
        })
        
        print(cities.count)
        print(cityLocations.count)
      }
    }
    return false
  }
  
  @IBAction func addNewCity(sender: UIBarButtonItem)
  {
    let aCity = City(context: context)
    cities.append(aCity)
    setEditing(true, animated: true)
    tableView.reloadData()
  }
}

extension CitiesViewController      //location functions
{
  func tryGeocode(from string: String?, completion: @escaping CLGeocodeCompletionHandler)
  {
    let geocoder = CLGeocoder()
    geocoder.geocodeAddressString(string ?? "", completionHandler: completion)
  }
}

struct CityLocation
{
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







