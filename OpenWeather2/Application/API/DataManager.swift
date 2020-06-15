//
//  DataManager.swift
//  OpenWeather2
//
//  Created by Hoang Trong Kien on 6/15/20.
//  Copyright © 2020 Hoang Trong Kien. All rights reserved.
//

import UIKit

enum DataManagerError: Error {
  case Unknown
  case FailedRequest
  case InvalidResponse
  case CityNotFound
}

class DataManager {
  
  typealias WeatherDataCompletion = (AnyObject?, DataManagerError?) -> ()
  
  let baseURL: URL
  
  init(baseURL: URL) {
    self.baseURL = baseURL
  }
  
  // MARK: - Request API
  func weatherDataForLocation(city: String, completion: @escaping WeatherDataCompletion) {
    
    // MARK: - Initialize URL
    let url = URL(string: "\(baseURL)&q=\(city)")
    guard let safeURL = url else { return }
    
    // MARK: - Fetch Data
    URLSession.shared.dataTask(with: safeURL) {
      (data, response, error) in
      self.didFetchWeatherData(data: data,
                               response: response,
                               error: error,
                               completion: completion)
    }.resume()
  }
  
  // MARK: - Fetch Weather Data
  private func didFetchWeatherData(data: Data?,
                                   response: URLResponse?,
                                   error: Error?,
                                   completion: @escaping WeatherDataCompletion) {
    if let _ = error {
      completion(nil, .FailedRequest)
    }
    else if let data = data, let response = response as? HTTPURLResponse {
      if response.statusCode == 200 {
        processWeatherData(data: data, completion: completion)
      }
      else if response.statusCode == 404 {
        completion(nil, .CityNotFound)
      }
      else {
        completion(nil, .InvalidResponse)
      }
    }
    else {
      completion(nil, .Unknown)
    }
  }
  
  private func processWeatherData(data: Data,
                                  completion: @escaping WeatherDataCompletion) {
    if let JSON = try? JSONSerialization.jsonObject(with: data, options: []) as AnyObject {
      completion(JSON, nil)
    }
    else {
      completion(nil, .InvalidResponse)
    }
  }
}
