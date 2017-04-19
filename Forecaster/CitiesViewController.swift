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
  let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
  @IBOutlet weak var tableView: UITableView!
  var delegate: CitiesViewControllerProtocol!
  
  init(delegate: CitiesViewControllerProtocol)
  {
    self.delegate = delegate
  }

  override func viewDidLoad()
  {
    super.viewDidLoad()
    navigationItem.rightBarButtonItem = editButtonItem
    
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "City")
    do
    {
      if let fetchResults = try context.fetch(fetchRequest) as? [City]
      {
        cities = fetchResults
      }
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
  
//  func cityAdded(location: String)
//  {
//    cityNameOrZipLocation(location: location)
//  }
//  
//  func cityNameOrZipLocation(location: String)
//  {
//    let geocoder = CLGeocoder()
//    geocoder.geocodeAddressString(location, completionHandler: {
//      placemarks, error in
//      if let geocodeError = error
//      {
//        print(geocodeError.localizedDescription)
//      }
//      else
//      {
//        if let placemark = placemarks?[0]
//        {
//          let locationCoordinates = (placemark.location?.coordinate)!
//          let cityLatitude = locationCoordinates.latitude
//          let cityLongitude = locationCoordinates.longitude
//          let cityName = (placemark.name)
//          let aCity = City(latitude: cityLatitude, longitude: cityLongitude, name: cityName!)
//          self.cities.append(aCity)
//        }
//      }
//    })
//  }
}

//struct City
//{
//  var locationLatitude = Double()
//  var locationLongitude = Double()
//  var cityName = String()
//  
//  init(latitude: Double, longitude: Double, name: String)
//  {
//    self.locationLatitude = latitude
//    self.locationLongitude = longitude
//    self.cityName = name
//  }
//}

extension CitiesViewController          //table view code
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
    if selectedCity.name != ""
    {
      delegate.citiesViewControllerDidSend(latitude: selectedCity.latitude, longitude: selectedCity.longitude, name: selectedCity.name!)
    }
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
      let indexPath = tableView.indexPath(for: cell)
    {
      let selectedCity = cities[indexPath.row]
      if textField.text != ""
      {
        if textField == cell.locationTextField
        {
          selectedCity.name = textField.text
          cell.locationTextField.resignFirstResponder()
        }
      }
    }
    return false
  }
  
  @IBAction func addNewCity(sender: UIBarButtonItem)
  {
    let aCity = NSEntityDescription.insertNewObject(forEntityName: "City", into: context) as! City
    cities.append(aCity)
    setEditing(true, animated: true)
    tableView.reloadData()
  }

}







