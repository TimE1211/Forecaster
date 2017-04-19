//
//  CityCell.swift
//  Forecaster
//
//  Created by Timothy Hang on 4/18/17.
//  Copyright © 2017 Timothy Hang. All rights reserved.
//

import UIKit

class CityCell: UITableViewCell
{
  @IBOutlet weak var cityNameLabel: UILabel!
//  @IBOutlet weak var cityCloudCoverLabel: UILabel!
//  @IBOutlet weak var cityTempLabel: UILabel!
  
  override func awakeFromNib()
  {
    super.awakeFromNib()
  }

  override func setSelected(_ selected: Bool, animated: Bool)
  {
    super.setSelected(selected, animated: animated)
  }
}
