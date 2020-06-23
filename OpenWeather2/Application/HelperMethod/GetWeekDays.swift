//
//  GetWeekDays.swift
//  OpenWeather2
//
//  Created by Hoang Trong Kien on 6/23/20.
//  Copyright © 2020 Hoang Trong Kien. All rights reserved.
//

import UIKit

class GetWeekDays {
  static func getWeekdays() -> Int {
    // get day month year from system time
    let currentDate = Date()
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd"
    let dayString = dateFormatter.string(from: currentDate)
    dateFormatter.dateFormat = "MM"
    let monthString = dateFormatter.string(from: currentDate)
    dateFormatter.dateFormat = "yyyy"
    let yearString = dateFormatter.string(from: currentDate)
    
    let day = Int(dayString)!
    var month = Int(monthString)!
    var year = Int(yearString)!
    
    if month < 3 {
      month += 12
      year -= 1
    }
    
    // cong thuc tinh thu trong tuan
    let weekday = (day+2*month+(3*(month+1)) / 5 + year + (year / 4)) % 7
    // weekday = 0 => Sunday
    // weeyday = 1 => Monday
    // weekday = 6 => Saturday
    return weekday
  }
}
