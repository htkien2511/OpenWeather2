//
//  WeatherCollectionViewCell.swift
//  OpenWeather2
//
//  Created by Hoang Trong Kien on 6/15/20.
//  Copyright © 2020 Hoang Trong Kien. All rights reserved.
//

import UIKit

class WeatherCollectionViewCell: UICollectionViewCell {
  
  // MARK: - Outlet
  @IBOutlet weak var cityLabel: UILabel!
  @IBOutlet weak var iconImageView: UIImageView!
  @IBOutlet weak var temperatureLabel: UILabel!
  @IBOutlet weak var weatherDescriptionLabel: UILabel!
  
  // MARK: - Outlet Detail Weather
  @IBOutlet var tempDetailArray: Array<UILabel>?
  @IBOutlet var iconDetailArray: Array<UIImageView>?
  @IBOutlet var dayDetailArray: Array<UILabel>?
  
  // MARK: - Action
  @IBAction func everyHourButtonTapped(_ sender: Any) {
    print("every hour tapped")
  }
  @IBAction func everyDayButtonTapped(_ sender: Any) {
    print("every day tapped")
  }
}
