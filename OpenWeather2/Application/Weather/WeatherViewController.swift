//
//  WeatherViewController.swift
//  OpenWeather2
//
//  Created by Hoang Trong Kien on 6/15/20.
//  Copyright © 2020 Hoang Trong Kien. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class WeatherViewController: UIViewController {
  
  // MARK: - Outlet
  @IBOutlet weak var updatedDayLabel: UILabel!
  @IBOutlet weak var updatedTimeLabel: UILabel!
  @IBOutlet weak var pageControl: UIPageControl!
  @IBOutlet weak var collectionView: UICollectionView!
  
  // MARK: - Properties
  private var items: [DataStructs] = []
  private var currentIndexItem: Int = 0
  
  
  // MARK: -
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setUpPageControl()
    setUpCollectionView()
  }
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    changePageControl()
  }
  
  func setUpCollectionView() {
    collectionView.isPagingEnabled = true
    collectionView.showsHorizontalScrollIndicator = false
  }
  
  func setUpPageControl() {
    pageControl.numberOfPages = items.count < 1 ? 1 : items.count
  }
  
  func changePageControl() {
    pageControl.currentPage = getCurrentIndex()
  }
  
  private func getCurrentIndex() -> Int {
    return Int(collectionView.contentOffset.x / collectionView.frame.width)
  }
  
  // MARK: - Action
  @IBAction func refreshButtonTapped(_ sender: Any) {
    print("Refresh Tapped")
  }
  
  @IBAction func addCityButtonTapped(_ sender: Any) {
    addCity() { (city) in
      let dataManager = DataManager(baseURL: API.AuthenticatedBaseURL)
      dataManager.weatherDataForLocation(city: city) { (data, error) in
        if let _ = error {
          DispatchQueue.main.async {
            self.showMessage(error: error!)
          }
        }
        else {
          DispatchQueue.main.async {
            self.items.append(data!)
            self.collectionView.reloadData()
            // go to new item
            let indexPath = IndexPath(item: self.items.count-1, section: 0)
            self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            self.showAlert(message: "SUCCESS")
            self.setUpPageControl()
          }
        }
      }
    }
  }
  
  // MARK: - Add alert for entering city name
  func addCity(completion: @escaping (_ city: String) -> ()) {
    let alertController = UIAlertController(title: "Title", message: "", preferredStyle: .alert)
    alertController.addAction(UIAlertAction(title: "Save", style: .default, handler: { alert -> Void in
      let textField = alertController.textFields![0] as UITextField
      var city = textField.text!
      while city.contains(" ") {
        city.removeAll { (char) -> Bool in
          char == " "
        }
      }
      completion(city)
    }))
    alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
    alertController.addTextField(configurationHandler: {(textField : UITextField!) -> Void in
      textField.placeholder = "Search"
    })
    self.present(alertController, animated: true, completion: nil)
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
}

// MARK: - Collection View Data Source
extension WeatherViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView,
                      numberOfItemsInSection section: Int) -> Int {
    // API khong kip tra ve nen items.count = 0 => failed
    return items.count < 1 ? 1 : items.count
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier,
                                                  for: indexPath) as! WeatherCollectionViewCell
    if items.count == 0 {
      loadDataFromAPI(cell, indexPath: indexPath, city: "Hue")
    }
    else {
      self.setUpWeather(cell, indexPath: indexPath)
      self.setUpEveryWeather(cell, indexPath: indexPath)
      self.setUpdatedTime()
    }
    
    cell.delegate = self
    return cell
  }
  
  // MARK: - Helper Method
  func loadDataFromAPI(_ cell: WeatherCollectionViewCell,
                       indexPath: IndexPath,
                       city: String) {
    let dataManager = DataManager(baseURL: API.AuthenticatedBaseURL)
    dataManager.weatherDataForLocation(city: city) { (data, error) in
      if let _ = error {
        print(error!)
      }
      else {
        DispatchQueue.main.async {
          self.items.append(data!)
          self.setUpWeather(cell, indexPath: indexPath)
          self.setUpEveryWeather(cell, indexPath: indexPath)
          self.setUpdatedTime()
        }
      }
    }
  }
  
  func setUpWeather(_ cell: WeatherCollectionViewCell,
                    indexPath: IndexPath) {
    let currentIndex = HelperWeather.getLastedIndex(data: items[indexPath.item]) + 1
    
    cell.cityLabel.text = String("\(self.items[indexPath.item].city.name)")
    cell.temperatureLabel.text = String("\(Int(self.items[indexPath.item].list[currentIndex].main.temp - 273))")
    cell.weatherDescriptionLabel.text = String("\(self.items[indexPath.item].list[currentIndex].weather[0].weatherDescription)")
    cell.iconImageView.image = UIImage(named: self.items[indexPath.item].list[currentIndex].weather[0].icon)
  }
  
  func setUpEveryWeather(_ cell: WeatherCollectionViewCell,
                         indexPath: IndexPath) {
    let detailEveryHour = HelperWeather.getWeatherEveryHour(data: items[indexPath.item])
    let lastedIndex = HelperWeather.getLastedIndex(data: items[indexPath.item])
    for i in 0..<6 {
      cell.tempDetailArray![i].text = String("\(Int(self.items[indexPath.item].list[i+lastedIndex].main.temp - 273))")
      cell.dayDetailArray![i].text = detailEveryHour[i+lastedIndex]
      cell.iconDetailArray![i].image = UIImage(named: self.items[indexPath.item].list[i+lastedIndex].weather[0].icon)
    }
  }
  
  func setUpdatedTime() {
    let currentDate = Date()
    // get time
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "HH:mm"
    updatedTimeLabel.text = dateFormatter.string(from: currentDate)
    
    // get date
    dateFormatter.dateFormat = "dd-MM-yyyy"
    updatedDayLabel.text = dateFormatter.string(from: currentDate)
  }
}

// MARK: - Collecion View Delegate Flow Layout
extension WeatherViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    return collectionView.frame.size
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 0
  }
}

// MARK: - Prepare Segue
extension WeatherViewController {
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.destination is AllCitiesViewController {
      let vc = segue.destination as! AllCitiesViewController
      vc.items = items
      vc.delegate = self
    }
  }
}

// MARK: - Protocol Delegate
extension WeatherViewController: ChangeButton {
  func isEveryDayTapped(_ isTapped: Bool) {
    if isTapped {
      print("Every Day Tapped")
    } else {
      print("Every Hour Tapped")
    }
  }
}

extension WeatherViewController: SelectedCity {
  func selectedCity(indexPath: IndexPath) {
    collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
  }
}
