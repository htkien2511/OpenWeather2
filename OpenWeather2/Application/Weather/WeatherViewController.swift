//
//  WeatherViewController.swift
//  OpenWeather2
//
//  Created by Hoang Trong Kien on 6/15/20.
//  Copyright © 2020 Hoang Trong Kien. All rights reserved.
//

import UIKit
import CoreData

private let reuseIdentifier = "Cell"

class WeatherViewController: UIViewController {
  
  // MARK: - Properties
  private var items: [NSManagedObject] = []
  
  
  // MARK: -
  override func viewDidLoad() {
    super.viewDidLoad()
    
    
  }
  
  // MARK: - Action
  @IBAction func addCityButtonTapped(_ sender: Any) {
  }
}

// MARK: - Collection View Data Source
extension WeatherViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    // API khong kip tra ve nen items.count = 0 => failed
    return items.count < 1 ? 1 : items.count
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier,
                                                  for: indexPath) as! WeatherCollectionViewCell
    loadDataFromAPI(cell, indexPath: indexPath)
    
    return cell
  }
  
  // MARK: - Helper Method
  func loadDataFromAPI(_ cell: WeatherCollectionViewCell, indexPath: IndexPath) {
    let dataManager = DataManager(baseURL: API.AuthenticatedBaseURL)
    dataManager.weatherDataForLocation(city: "Hue") { (data, error) in
      if let _ = error {
        print(error!)
      }
      else {
        //self.items.append(data!)
        DispatchQueue.main.async {
          
          let id = data!.city.id
          let city = data!.city.name
          let date = Date()
          let weather = CoreDataManager.sharedManager.insertWeather(id: id, city: city, updatedDate: date)
          self.items.append(weather!)
          print(self.items)
          self.setUpWeather(cell, indexPath: indexPath)
        }
      }
    }
  }
  
  func setUpWeather(_ cell: WeatherCollectionViewCell, indexPath: IndexPath) {
    cell.cityLabel.text = items[indexPath.item].value(forKeyPath: "cityName") as? String
//    cell.temperatureLabel.text = String("\(Int(self.items[indexPath.item].list[1].main.temp - 273))")
//    cell.weatherDescriptionLabel.text = String("\(self.items[indexPath.item].list[1].weather[0].weatherDescription)")
  }
}

// MARK: - Collecion View Delegate Flow Layout
extension WeatherViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    return collectionView.frame.size
  }
  
  
}
