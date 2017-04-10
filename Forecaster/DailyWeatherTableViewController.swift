//
//  DailyWeatherTableViewController.swift
//  Forecaster
//
//  Created by Timothy Hang on 4/10/17.
//  Copyright © 2017 Timothy Hang. All rights reserved.
//

import UIKit

class DailyWeatherTableViewController: UITableViewController
{
  var dailyWeather = [DailyWeather]()
  let formatter = DateFormatter()
  let today = Date()

  override func viewDidLoad()
  {
    super.viewDidLoad()
    let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
    backgroundImage.image = UIImage(named: "colourback_9006.jpg")
    self.view.insertSubview(backgroundImage, at: 0)
    //    http://stackoverflow.com/questions/27049937/how-to-set-a-background-image-in-xcode-using-swift
    //    http://wallpaperswide.com/rainy_weather-wallpapers.html = images.jpeg url
    //    http://www.zrarts.com/Websites-for-Background-Colors/ = colourback_9006.jpg url
    
    formatter.dateFormat = "EEE, MMM dd "
  }

  override func didReceiveMemoryWarning()
  {
    super.didReceiveMemoryWarning()
  }

  // MARK: - Table view data source

  override func numberOfSections(in tableView: UITableView) -> Int
  {
    return 1
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
  {
    return dailyWeather.count
  }


  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
  {
    let cell = tableView.dequeueReusableCell(withIdentifier: "DailyWeatherCell", for: indexPath) as! DailyWeatherCell
    
    var precipType = String()

    
    let aDailyWeather = dailyWeather[indexPath.row]
    
    let date = Date(timeIntervalSince1970: aDailyWeather.date)
    var oneDay = DateComponents()
    oneDay.day = 1
    let plusOneDay = Calendar.current.date(byAdding: oneDay, to: date)
    
    //http://stackoverflow.com/questions/26849237/swift-convert-unix-time-to-date-and-time
    cell.dateLabel.text = formatter.string(for: plusOneDay)
    
    if aDailyWeather.icon == "snow" || aDailyWeather.icon == "sleet"
    {
      precipType = "❄️"
    }
    else
    {
      precipType = "💧"
    }
    
    cell.precipProbLabel.text = String((aDailyWeather.precipProbability) * 100) + "%\(precipType)"
    cell.tempLabel.text = String(Int((aDailyWeather.temperatureMax + aDailyWeather.temperatureMin)/2))
    cell.windSpeedLabel.text = String(aDailyWeather.windSpeed) + "mph🌬"
    cell.backgroundColor = UIColor.clear
    
    if aDailyWeather.cloudCover < 0.25 && aDailyWeather.precipProbability < 1
    {
      cell.cloudCoverLabel.text = "☀️"
    }
    else if aDailyWeather.cloudCover < 0.25 && aDailyWeather.precipProbability == 1
    {
      cell.cloudCoverLabel.text = "☀️\(precipType)"
    }
    else if aDailyWeather.cloudCover >= 0.25 && aDailyWeather.cloudCover <= 0.75 && aDailyWeather.precipProbability < 1
    {
      cell.cloudCoverLabel.text = "🌤"
    }
    else if aDailyWeather.cloudCover > 0.75 && aDailyWeather.precipProbability < 1
    {
      cell.cloudCoverLabel.text = "☁️"
    }
    else if aDailyWeather.cloudCover >= 0.25 && aDailyWeather.cloudCover <= 0.75 && aDailyWeather.precipProbability == 1
    {
      cell.cloudCoverLabel.text = "🌦\(precipType)"
    }
    else if aDailyWeather.cloudCover > 0.75 && aDailyWeather.precipProbability == 1
    {
      cell.cloudCoverLabel.text = "🌧\(precipType)"
    }
    else
    {
      cell.cloudCoverLabel.text = ""
    }
    return cell
  }
}
