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
  var weatherAttributes = [Weather]()
  
  @IBOutlet weak var precipProbability: UILabel!
  @IBOutlet weak var windSpeed: UILabel!
  @IBOutlet weak var temperature: UILabel!
  @IBOutlet weak var cloudCover: UILabel!
  @IBOutlet weak var date: UILabel!
  @IBOutlet weak var hat: UILabel!
  @IBOutlet weak var umbrella: UILabel!
  @IBOutlet weak var boots: UILabel!
  
  
  override func viewDidLoad()
  {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
  }

  override func didReceiveMemoryWarning()
  {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  func didReceive(_ attributes: [Any])
  {
    dismiss(animated: true, completion: nil)
//    weatherAttributes.append(attributes)
//    precipProbability.text = Weather.precipProabablity
    loadView()
  }
}

