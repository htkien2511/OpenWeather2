//
//  HelperWeather.swift
//  OpenWeather2
//
//  Created by Hoang Trong Kien on 6/17/20.
//  Copyright © 2020 Hoang Trong Kien. All rights reserved.
//

import UIKit

class HelperWeather {
  
  static func getLastedIndex(data: DataStructs) -> Int {
    let currentDate = Date()
    
    // get index between lasted time and current time
    for index in 1..<data.list.count {
      if currentDate > data.list[index-1].date
        && currentDate < data.list[index].date {
        return index - 1
      }
    }
    return -1
  }
  
  static func getWeatherEveryHour(data: DataStructs) -> [Int : String] {
    
    let lastedIndex = getLastedIndex(data: data)
    
    // date formatter
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "HH:mm"
    
    // get every hour
    var next6TimesHour: [Int:String] = [:]
    for i in lastedIndex ..< lastedIndex+6 {
      next6TimesHour[i] = dateFormatter.string(from: data.list[i].date)
    }
    
    return next6TimesHour
  }
}
