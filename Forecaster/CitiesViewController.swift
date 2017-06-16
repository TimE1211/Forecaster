//
//  CitiesViewController.swift
//  Forecaster
//
//  Created by Timothy Hang on 4/18/17.
//  Copyright © 2017 Timothy Hang. All rights reserved.
//

import UIKit
import CoreLocation

class CitiesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate
{
  var cities = [City]()
  
  @IBOutlet weak var tableView: UITableView!

  override func viewDidLoad()
  {
    super.viewDidLoad()
    //cities add saved cites from saved data
  }

  override func didReceiveMemoryWarning()
  {
    super.didReceiveMemoryWarning()
  }
}

extension CitiesViewController          //table view functions
{
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
  {
    return cities.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
  {
    let cell = tableView.dequeueReusableCell(withIdentifier: "CityCell", for: indexPath)
    
    let aCity = cities[indexPath.row]
    cell.textLabel?.text = aCity.name
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
  {
    tableView.deselectRow(at: indexPath, animated: true)
    City.current = cities[indexPath.row]
  }

  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
  {
    if editingStyle == .delete
    {
//      let cityToDelete = cities[indexPath.row]
//      remove city from saved data
      cities.remove(at: indexPath.row)
      tableView.deleteRows(at: [indexPath], with: .automatic)
    }
  }
  
  @IBAction func addNewCity(sender: UIBarButtonItem)
  {
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

          City.current = City(latitude: cityLatitude, longitude: cityLongitude, name: city)
          self.cities.append(City.current)
          //added to saved data
        }
      })
    }
    
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    
    alert.addAction(confirmAction)
    alert.addAction(cancelAction)
    present(alert, animated: true, completion: nil)
  }
}

extension CitiesViewController      //location functions maybe should move to location manager
{
  func tryGeocode(from string: String?, completion: @escaping CLGeocodeCompletionHandler)
  {
    let geocoder = CLGeocoder()
    geocoder.geocodeAddressString(string ?? "", completionHandler: completion)
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





