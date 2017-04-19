//
//  CitySelectorViewController.swift
//  Forecaster
//
//  Created by Timothy Hang on 4/18/17.
//  Copyright © 2017 Timothy Hang. All rights reserved.
//

import UIKit

protocol CitySelectorViewControllerProtocol
{
  func cityAdded(location: String)
}

class CitySelectorViewController: UIViewController
{
  var location = String()
  var delegate: CitySelectorViewControllerProtocol!
  
  init(delegate: CitySelectorViewControllerProtocol)
  {
//    super.init()
    self.delegate = delegate
  }
  
  @IBOutlet weak var locationTextField: UITextField!

  override func viewDidLoad()
  {
    super.viewDidLoad()
  }

  override func didReceiveMemoryWarning()
  {
    super.didReceiveMemoryWarning()
  }
  
  @IBAction func addCityButton(_ sender: UIButton)
  {
    if locationTextField.text != ""
    {
      location = locationTextField.text!
    }
    delegate.cityAdded(location: location)
    self.dismiss(animated: true, completion: nil)
  }
}






