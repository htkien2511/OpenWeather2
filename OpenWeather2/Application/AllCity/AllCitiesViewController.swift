//
//  AllCities.swift
//  OpenWeather2
//
//  Created by Hoang Trong Kien on 6/17/20.
//  Copyright © 2020 Hoang Trong Kien. All rights reserved.
//

import UIKit

protocol SelectedCity: class {
  func selectedCity(indexPath: IndexPath)
}

protocol AddCity: class {
  func reuseAddCity()
}

private let reuseIdentifier = "allCitiesCell"

class AllCitiesViewController: UIViewController {
  
  // MARK: - Outlet
  @IBOutlet weak var allCitiesTableView: UITableView!
  
  // MARK: - Properties
  var items: [DataStructs] = []
  
  weak var selectedCityDelegate: SelectedCity?
  weak var addCityDelegate: AddCity?
  
  // MARK: -
  override func viewDidLoad() {
    super.viewDidLoad()
    definesPresentationContext = true
    setUpElements()
  }
  
  func setUpElements() {
    allCitiesTableView.tableFooterView = UIView()
    
    let allCitiesTableViewCell = UINib(nibName: "AllCitiesTableViewCell", bundle: nil)
    allCitiesTableView.register(allCitiesTableViewCell, forCellReuseIdentifier: reuseIdentifier)
  }
  
  // MARK: - Show alert response users
  func showMessage(error: DataManagerError) {
    switch error {
    case .InvalidResponse:
      showAlert(message: "Invalid Response")
    case .FailedRequest:
      showAlert(message: "Failed Request")
    case .CityNotFound:
      showAlert(message: "City Not Found")
    default:
      showAlert(message: "Unknown Error")
    }
  }
  
  func showAlert(message: String) {
    let alert = UIAlertController(title: message, message: "", preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    self.present(alert, animated: true, completion: nil)
  }
  
  // MARK: - Action
  // reuse Add function in WeatherViewController
  @IBAction func addButtonTapped(_ sender: Any) {
    addCityDelegate?.reuseAddCity()
  }
  
}

// MARK: - Table View Data Source
extension AllCitiesViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return items.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! AllCitiesTableViewCell
    cell.city.text = items[indexPath.row].city.name
    cell.country.text = items[indexPath.row].city.country
    
    let currentIndex = HelperWeather.getLastedIndex(data: items[indexPath.item]) + 1
    cell.temperature.text = String("\(Int(self.items[indexPath.item].list[currentIndex].main.temp - 273))")
    cell.icon.image = UIImage(named: self.items[indexPath.item].list[currentIndex].weather[0].icon)
    
    return cell
  }
}

extension AllCitiesViewController: UITableViewDelegate {
  // fixed heigh of row. If don't have that. Unable to simultaneously satisfy constraints.
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 80
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    self.selectedCityDelegate?.selectedCity(indexPath: indexPath)
    self.dismiss(animated: true, completion: nil)
  }
}
