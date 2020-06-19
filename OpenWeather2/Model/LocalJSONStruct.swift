//
//  localJSONStruct.swift
//  OpenWeather2
//
//  Created by Hoang Trong Kien on 6/19/20.
//  Copyright © 2020 Hoang Trong Kien. All rights reserved.
//

import UIKit

struct localJSONStructElement: Codable {
  let name, capital, region: String
}

typealias LocalJSONStruct = [localJSONStructElement]
