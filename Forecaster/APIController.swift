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
  func apiControllerDidSend(results1: [String: Any], results2: [String: Any])
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
    let urlPath = "https://api.darksky.net/forecast//\(latitude),\(longitude)"
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
        let currentlyDictionary = dictionary["currently"] as? [String: Any],
        let dailyDictionary = dictionary["daily"] as? [String: Any]
      {
        DispatchQueue.main.async              //switching to the main thread
        {
          self.delegate.apiControllerDidSend(results1: currentlyDictionary, results2: dailyDictionary)
        }
//        if let dictionary = self.parseJSON(data)
//        {
//          if let currentlyDictionary = dictionary["currently"] as? [String: Any]
//          {
//            self.delegate?.didSend(results1)
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

