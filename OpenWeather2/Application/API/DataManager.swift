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
  
  typealias WeatherDataCompletion = (DataStructs?, DataManagerError?) -> ()
  
  let baseURL: URL
  
  init(baseURL: URL) {
    self.baseURL = baseURL
  }
  
  // MARK: - Request API
  func weatherDataForLocation(city: String, completion: @escaping WeatherDataCompletion) {
    
    // MARK: - Initialize URL
    let url = URL(string: "\(baseURL)&q=\(city)")
    guard let safeURL = url else { return }
    
    // MARK: - Request URL
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
  
  // MARK: - Parse JSON Data to DataStructures
  private func processWeatherData(data: Data,
                                  completion: @escaping WeatherDataCompletion) {
    do {
      let decoder = JSONDecoder()
      
      // MARK: - Change date format for parsing date from JSON Data
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
      decoder.dateDecodingStrategy = .formatted(dateFormatter)
      
      let dataStruct = try decoder.decode(DataStructs.self, from: data)
      completion(dataStruct, nil)
    } catch {
      completion(nil, .InvalidResponse)
    }
  }
}
