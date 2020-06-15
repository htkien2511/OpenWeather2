//
//  DataStructures.swift
//  OpenWeather2
//
//  Created by Hoang Trong Kien on 6/15/20.
//  Copyright © 2020 Hoang Trong Kien. All rights reserved.
//

import UIKit

// MARK: - Weather
struct DataStructures: Codable {
  let list: [List]
  let city: City
}

// MARK: - List
struct List: Codable {
  let main: Main
  let weather: [Weather]
  let date: Date
  
  enum CodingKeys: String, CodingKey {
    case main, weather
    case date = "dt_txt"
  }
}

struct Main: Codable {
  let temp: Float
}

struct Weather: Codable {
  let weatherDescription: String
  let icon: String
  
  enum CodingKeys: String, CodingKey {
    case weatherDescription = "description"
    case icon
  }
}

// MARK: - City
struct City: Codable {
  let id: Int
  let name: String
}
