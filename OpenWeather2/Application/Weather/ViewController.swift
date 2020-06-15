//
//  ViewController.swift
//  OpenWeather2
//
//  Created by Hoang Trong Kien on 6/15/20.
//  Copyright © 2020 Hoang Trong Kien. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    
    loadData()
  }
  
  private func loadData() {
    let dataManager = DataManager(baseURL: API.AuthenticatedBaseURL)
    dataManager.weatherDataForLocation(city: "DaNang") { (response, error) in
      if let _ = error {
        print(error!)
      }
      else {
        print(response!)
      }
    }
  }

}

