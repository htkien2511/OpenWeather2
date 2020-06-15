//
//  API.swift
//  OpenWeather2
//
//  Created by Hoang Trong Kien on 6/15/20.
//  Copyright © 2020 Hoang Trong Kien. All rights reserved.
//

import UIKit

struct API {
  static let BaseURL = URL(string: "https://api.openweathermap.org/data/2.5/forecast")!
  static let APIKey = "0e0877237e3aa921319e1e984c87f89d"
  
  static var AuthenticatedBaseURL: URL {
    return URL(string: "\(BaseURL)?APPID=\(APIKey)")!
  }
}
