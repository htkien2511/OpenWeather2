//
//  AddCityViewController.swift
//  OpenWeather2
//
//  Created by Hoang Trong Kien on 6/17/20.
//  Copyright © 2020 Hoang Trong Kien. All rights reserved.
//

import UIKit

protocol AddCity: class {
  func addCity(name: String)
}

class AddCityViewController: UIViewController {
  
  // MARK: - Outlet
  @IBOutlet weak var addCityTableView: UITableView!
  @IBOutlet weak var addCitySearchBar: UISearchBar!
  
  // MARK: - Properties
  var dataStruct: LocalJSONStruct = []
  var nameCity: [String] = []
  var filteredData: [String]!
  
  weak var addCityDelegate: AddCity?
  
  // MARK: - 
  override func viewDidLoad() {
    super.viewDidLoad()
    
    readFileJSON()
    loadDataIntoArray()
    setUpElements()
  }
  
  func loadDataIntoArray() {
    for item in dataStruct {
      let name = "\(item.capital), \(item.name), \(item.region)"
      nameCity.append(name)
    }
  }
  
  func readFileJSON() {
    if let path = Bundle.main.path(forResource: "capital_city_region", ofType: "json") {
      do {
        let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
        let decoder = JSONDecoder()
        self.dataStruct = try decoder.decode(LocalJSONStruct.self, from: data)
      } catch {
        print("Can't read json file!")
      }
    }
  }
  
  func setUpElements() {
    filteredData = nameCity
    
    addCityTableView.dataSource = self
    addCitySearchBar.delegate = self
    addCityTableView.tableFooterView = UIView()
  }
}

// MARK: - Table View Data Source
extension AddCityViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return filteredData.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "addCityCell", for: indexPath)
    cell.textLabel?.text = filteredData[indexPath.row]
    return cell
  }
}

// MARK: - Table View Delegate
extension AddCityViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    // when press a city. Filter city's name of one's string
    let selectedString = filteredData[indexPath.row]
    var i = 0
    var nameCityContainComma: String
    repeat {
      i += 1
      nameCityContainComma = String(selectedString[..<selectedString.index(selectedString.startIndex, offsetBy: i)])
    } while !nameCityContainComma.contains(",")
    // remove comma
    let nameCity = String(nameCityContainComma.dropLast())
    addCityDelegate?.addCity(name: nameCity)
  }
}

// MARK: - Search Bar Delegate
extension AddCityViewController: UISearchBarDelegate {
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    filteredData = searchText.isEmpty ? nameCity : nameCity.filter({ (item) -> Bool in
      return item.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
    })
    addCityTableView.reloadData()
  }
  
  func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
    addCitySearchBar.showsCancelButton = true
  }
  
  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    addCitySearchBar.showsCancelButton = false
    addCitySearchBar.text = ""
    addCitySearchBar.resignFirstResponder()
    filteredData = nameCity
    addCityTableView.reloadData()
  }
}
