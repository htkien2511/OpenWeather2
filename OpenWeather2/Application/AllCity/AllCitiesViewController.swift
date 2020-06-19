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
protocol DeletedCity: class {
  func deletedCity(items: [DataStructs])
}

private let reuseIdentifier = "allCitiesCell"

class AllCitiesViewController: UIViewController {
  
  // MARK: - Outlet
  @IBOutlet weak var allCitiesTableView: UITableView!
  
  // MARK: - Properties
  var items: [DataStructs] = []
  
  weak var selectedCityDelegate: SelectedCity?
  weak var deletedCityDelegate: DeletedCity?
  
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
  
  // MARK: - Action
  @IBAction func addButtonTapped(_ sender: Any) {
    // when dismiss vc. current vc changed.
    // if don't have pvc below. AddCityViewController will not call
    weak var pvc = self.presentingViewController
    // pvc = WeatherViewController
    self.dismiss(animated: true) {
      pvc?.performSegue(withIdentifier: "addCity", sender: nil)
    }
    
  }
  @IBAction func backButtonTapped(_ sender: Any) {
    dismiss(animated: true, completion: nil)
  }
}

// MARK: - Table View Data Source
extension AllCitiesViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView,
                 numberOfRowsInSection section: Int) -> Int {
    return items.count
  }
  
  func tableView(_ tableView: UITableView,
                 cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier,
                                             for: indexPath) as! AllCitiesTableViewCell
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
  
  func tableView(_ tableView: UITableView,
                 trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    let delete = UIContextualAction(style: .normal, title: "Delete") { (action, view, nil) in
      self.items.remove(at: indexPath.row)
      self.allCitiesTableView.deleteRows(at: [indexPath], with: .automatic)
      tableView.reloadData()
      self.deletedCityDelegate?.deletedCity(items: self.items)
    }
    delete.backgroundColor = #colorLiteral(red: 0, green: 0.6039215686, blue: 0.7803921569, alpha: 1)
    delete.image = #imageLiteral(resourceName: "trash")
    let config = UISwipeActionsConfiguration(actions: [delete])
    config.performsFirstActionWithFullSwipe = false
    // if it has 1 city. can't delete
    return items.count > 1 ? config : nil
  }
}
