//
//  GetUnderImage.swift
//  OpenWeather2
//
//  Created by Hoang Trong Kien on 6/23/20.
//  Copyright © 2020 Hoang Trong Kien. All rights reserved.
//

import UIKit

class GetUnderImage {
  static func getImageName(icon: String) -> String {
    switch icon {
    case "11d", "11n":
      return "thunderstorm"
    case "09d", "09n":
      return "drizzle"
    case "10d", "10n":
      return "rain"
    case "13d", "13n":
      return "snow"
    case "01d", "01n":
      return "clear"
    case "02d", "02n":
      return "few-clouds"
    case "03d", "03n":
      return "scattered-clouds"
    case "04d", "04n":
      return "overcast-clouds"
    default:
      return "cloud"
    }
  }
}
