//
//  AddCityViewController.swift
//  OpenWeather2
//
//  Created by Hoang Trong Kien on 6/17/20.
//  Copyright © 2020 Hoang Trong Kien. All rights reserved.
//

import UIKit

class AddCityViewController: UIViewController {
  
  // MARK: - Outlet
  @IBOutlet weak var addCityTableView: UITableView!
  @IBOutlet weak var addCitySearchBar: UISearchBar!
  
  let data = ["New York, NY", "Los Angeles, CA", "Chicago, IL", "Houston, TX",
  "Philadelphia, PA", "Phoenix, AZ", "San Diego, CA", "San Antonio, TX",
  "Dallas, TX", "Detroit, MI", "San Jose, CA", "Indianapolis, IN",
  "Jacksonville, FL", "San Francisco, CA", "Columbus, OH", "Austin, TX",
  "Memphis, TN", "Baltimore, MD", "Charlotte, ND", "Fort Worth, TX"]
  
  var filteredData: [String]!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setUpElements()
  }
  
  func setUpElements() {
    filteredData = data
    
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

// MARK: - Search Bar Delegate
extension AddCityViewController: UISearchBarDelegate {
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    filteredData = searchText.isEmpty ? data : data.filter({ (item) -> Bool in
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
    filteredData = data
    addCityTableView.reloadData()
  }
}
