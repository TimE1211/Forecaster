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
  func citiesViewControllerDidSend(latitude: Double, longitude: Double)
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
    let fetchRequest: NSFetchRequest<City> = City.fetchRequest()
    do
    {
      let fetchResults = try context.fetch(fetchRequest)
      cities = fetchResults
    } catch
    {
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
//(UIApplication.shared.delegate as! AppDelegate).saveContext()
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
  {
    return cities.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
  {
    let cell = tableView.dequeueReusableCell(withIdentifier: "CityCell", for: indexPath) as! CityCell
    
    let aCity = cities[indexPath.row]
    cell.locationTextField.text = aCity.name
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
  {
    tableView.deselectRow(at: indexPath, animated: true)
    
    let selectedCity = cities[indexPath.row]
      delegate.citiesViewControllerDidSend(latitude: selectedCity.latitude, longitude: selectedCity.longitude)
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
  
  @IBAction func addNewCity(sender: UIBarButtonItem)
  {
    let aCity = City(context: context)
    cities.append(aCity)
    
    let alert = UIAlertController(title: "New City", message: "Please Enter a Zip Code or City Name, State then Confirm", preferredStyle: .alert)
    
    alert.addTextField { textField in
      textField.placeholder = "City, State, or Zip Code"
      textField.keyboardType = .default
    }
    
    let confirmAction = UIAlertAction(title: "Confirm", style: .default) { [weak self] _ in
      guard let `self` = self else { return }
      
      guard let city = alert.textFields?.first?.text, city != "" else
      {
        self.pleaseEnterDataAlert()
        return
      }
      self.tryGeocode(from: city, completion: { placemarks, error in
        if let geocodeError = error
        {
          print(geocodeError.localizedDescription)
        }
        else if let placemark = placemarks?.first, let coordinate = placemark.location?.coordinate
        {
          let cityLatitude = coordinate.latitude
          let cityLongitude = coordinate.longitude
          let aCityLocation = CityLocation(latitude: cityLatitude, longitude: cityLongitude, name: city)
          
          self.cityLocations.append(aCityLocation)
          
          //need to set current city here and then present the main vc

        }
      })
    }
    
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    
    alert.addAction(confirmAction)
    alert.addAction(cancelAction)
    present(alert, animated: true, completion: nil)
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

extension CitiesViewController        //alert warnings
{
  func pleaseEnterDataAlert()
  {
    let errorAlert = UIAlertController(title: "Error - Incorrect Data", message: "Please enter a valid City or Zip Code", preferredStyle: .deviceSpecific)
    
    let action = UIAlertAction(title: "Okay", style: .default, handler: nil)
    errorAlert.addAction(action)
    self.present(errorAlert, animated: true, completion: nil)
  }
}

extension UIAlertControllerStyle          //for ipads
{
  static var deviceSpecific: UIAlertControllerStyle
  {
    if UIDevice.current.userInterfaceIdiom == .pad
    {
      return .alert
    }
    return .actionSheet
  }
}





