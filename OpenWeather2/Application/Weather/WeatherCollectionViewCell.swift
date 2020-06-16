//
//  WeatherCollectionViewCell.swift
//  OpenWeather2
//
//  Created by Hoang Trong Kien on 6/15/20.
//  Copyright © 2020 Hoang Trong Kien. All rights reserved.
//

import UIKit

class WeatherCollectionViewCell: UICollectionViewCell {
    
  @IBOutlet weak var weatherGerenal: UIView!
  @IBAction func everyHourButtonTapped(_ sender: Any) {
    print("every hour tapped")
  }
  @IBAction func everyDayButtonTapped(_ sender: Any) {
    print("every day tapped")
  }
}
