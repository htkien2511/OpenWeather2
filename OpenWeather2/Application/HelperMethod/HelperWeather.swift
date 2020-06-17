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
    print(next6TimesHour)
    return next6TimesHour
  }
  
  static func getWeatherEveryDay(data: DataStructs) -> [Int: String] {
    var currentIndex = getLastedIndex(data: data) + 1

    // date formatter
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd-MM"
    
    // get every hour
    var next6TimesDay: [Int:String] = [:]
    while currentIndex < data.list.count {
      next6TimesDay[currentIndex] = dateFormatter.string(from: data.list[currentIndex].date)
      currentIndex += 8
    }
    
    // next6TimesDay has 5 element => Add 1 element
    if next6TimesDay.count < 6 {
      next6TimesDay[39] = dateFormatter.string(from: data.list[39].date)
    }
    
    return next6TimesDay
  }
}
