//
//  ViewController.swift
//  Forecaster
//
//  Created by Timothy Hang on 4/5/17.
//  Copyright © 2017 Timothy Hang. All rights reserved.
//

import UIKit

class ForecasterViewController: UIViewController, APIControllerProtocol
{
  var weatherObjects = [Weather]()
  var apiController: APIController!   //ApiController Object not made yet, need var apiController to call search url function from class ApiController
  let formatter = DateFormatter()
  let today = Date()
  
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
    view.backgroundColor = UIColor.orange
    temperatureLabel.text = ""
    
    for label in [hatLabel, bootsLabel, umbrellaLabel, cloudCoverLabel]
    {
      label?.isHidden = true          //hiding labels that arent ready yet
    }
    
    if let label = temperatureLabel
    {
      label.layer.cornerRadius = label.frame.width/2        //how to make a circle by david
      label.layer.borderColor = UIColor.black.cgColor
      label.layer.borderWidth = 5.0
      label.layer.backgroundColor = UIColor.white.cgColor
    }
    
    apiController = APIController(delegate: self)
    apiController.searchDarkSkyFor(latitude: "28.540923", longitude: "-81.38216")
    
  }

  override func didReceiveMemoryWarning()
  {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func apiControllerDidReceive(results: [String : Any])
  {
    let currentWeather = Weather(weatherDictionary: results)    //argument passed thru delegate = currently key value dictionary
    self.reloadView(with: currentWeather)
  }
  
  func reloadView(with weather: Weather)
  {
    windSpeedLabel.text = String(weather.windSpeed) + "mph🌬"
    precipProbabilityLabel.text = String(weather.precipProbability) + "%💧"
    temperatureLabel.text = String(weather.temperature) + "º"
    cloudCoverLabel.text = String(weather.cloudCover)
  }
}

