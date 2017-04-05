//
//  APIController.swift
//  Forecaster
//
//  Created by Timothy Hang on 4/5/17.
//  Copyright © 2017 Timothy Hang. All rights reserved.
//


import Foundation

protocol APIControllerProtocol
{
  func didReceive(_ descriptors: [Any])
}

class APIController
{
  var delegate: APIControllerProtocol?
  
  init(delegate: APIControllerProtocol)
  {
    self.delegate = delegate
  }
  
  func searchDarkSkyFor(_ searchTerm:String)
  {
    let urlPath = "https://api.darksky.net/forecast/61c89a172b4204bb03af10e2342671cd/28.540923,-81.38216"
    let url = URL(string: urlPath)!
    let session = URLSession.shared
    let task = session.dataTask(with: url, completionHandler: {data, response, error -> Void in
      print("Task completed")
      if let error = error
      {
        print(error.localizedDescription)
      }
      else
      {
        if let dictionary = self.parseJSON(data!)
        {
          if let descriptors = dictionary["discriptors"] as? [Any]
          {
            self.delegate?.didReceive(descriptors)
          }
        }
      }
    })
    task.resume()
  }
  
  func parseJSON(_ data: Data) -> [String: Any]?
  {
    do
    {
      let json = try JSONSerialization.jsonObject(with: data, options: [])
      if let dictionary = json as? [String: Any]
      {
        return dictionary
      }
      else
      {
        return nil
      }
    }
    catch
    {
      print(error)
      return nil
    }
  }
}





