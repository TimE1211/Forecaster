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
  func apiControllerDidReceive(results: [String: Any])
}

class APIController
{
  var delegate: APIControllerProtocol
  
  init(delegate: APIControllerProtocol)
  {
    self.delegate = delegate
  }
  
  func searchDarkSkyFor(latitude: String, longitude: String)
  {
    let urlPath = "https://api.darksky.net/forecast/61c89a172b4204bb03af10e2342671cd/\(latitude),\(longitude)"
    let url = URL(string: urlPath)!
    let session = URLSession.shared
    let task = session.dataTask(with: url, completionHandler: {data, response, error -> Void in
      print("Task completed")
      if let error = error
      {
        print(error.localizedDescription)
      }
      else if let data = data,
        let dictionary = self.parseJSON(data),
        let currentlyDictionary = dictionary["currently"] as? [String: Any]
      {
        DispatchQueue.main.async              //switching to the main thread
        {
          self.delegate.apiControllerDidReceive(results: currentlyDictionary)
        }
//        if let dictionary = self.parseJSON(data)
//        {
//          if let currentlyDictionary = dictionary["currently"] as? [String: Any]
//          {
//            self.delegate?.didReceive(attributes)
//          }
//        }
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





