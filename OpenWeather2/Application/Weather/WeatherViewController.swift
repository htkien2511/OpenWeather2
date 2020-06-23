//
//  WeatherViewController.swift
//  OpenWeather2
//
//  Created by Hoang Trong Kien on 6/15/20.
//  Copyright © 2020 Hoang Trong Kien. All rights reserved.
//

import UIKit
import Charts

private let reuseIdentifier = "Cell"

class WeatherViewController: UIViewController {
  
  // MARK: - Outlet
  @IBOutlet weak var updatedDayLabel: UILabel!
  @IBOutlet weak var updatedTimeLabel: UILabel!
  @IBOutlet weak var pageControl: UIPageControl!
  @IBOutlet weak var collectionView: UICollectionView!
  @IBOutlet weak var refreshButton: UIButton!
  @IBOutlet weak var addButton: UIButton!
  @IBOutlet weak var cityButton: UIButton!
  
  // MARK: - Properties
  private var items: [DataStructs] = []
  private var isEveryDaysChecked = false
  
  
  // MARK: -
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setUpHeaderButton()
    setUpPageControl()
    setUpCollectionView()
  }
  
  func setUpHeaderButton() {
    addButton.corner()
    addButton.border()
    addButton.shadow()
    cityButton.corner()
    cityButton.border()
    cityButton.shadow()
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
    let dataManager = DataManager(baseURL: API.AuthenticatedBaseURL)
    let currentIndex = pageControl.currentPage
    let city = items[currentIndex].city.name
    dataManager.weatherDataForLocation(city: city) { (data, error) in
      if let _ = error {
        print(error!)
      }
      else {
        DispatchQueue.main.async {
          self.items[currentIndex] = data!
          self.collectionView.reloadData()
          self.setUpdatedTime()
          
          // reload animation
          let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
          rotateAnimation.fromValue = 0.0
          rotateAnimation.toValue = CGFloat(.pi * 2.0)
          rotateAnimation.duration = 1

          self.refreshButton.layer.add(rotateAnimation, forKey: nil)
        }
      }
    }
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
      loadDataFromAPI(cell, indexPath: indexPath, city: "DaNang")
      self.setUpHourNDayButton(cell)
    }
    else {
      self.setUpWeather(cell, indexPath: indexPath)
      if self.isEveryDaysChecked {
        self.setUpEveryDays(cell, indexPath: indexPath)
        self.setUpLineChartViewForEveryWeeks(cell, indexPath: indexPath)
      } else {
        self.setUpEveryHours(cell, indexPath: indexPath)
        self.setUpLineChartViewForEveryDays(cell, indexPath: indexPath)
      }
      self.setUpdatedTime()
      self.setUpHourNDayButton(cell)
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
          self.setUpdatedTime()
          self.setUpEveryHours(cell, indexPath: indexPath)
          self.setUpLineChartViewForEveryDays(cell, indexPath: indexPath)
        }
      }
    }
  }
  
  func setUpWeather(_ cell: WeatherCollectionViewCell,
                    indexPath: IndexPath) {
    cell.generalWeatherView.border()
    cell.cityLabel.shadow()
    cell.temperatureLabel.shadow()
    cell.weatherDescriptionLabel.shadow()
    for i in 0..<6 {
      cell.viewDetailArray![i].border()
    }
    
    // set information for general weather
    let currentIndex = HelperWeather.getLastedIndex(data: items[indexPath.item]) + 1
    
    cell.cityLabel.text = String("\(self.items[indexPath.item].city.name)")
    cell.temperatureLabel.text = String("\(Int(self.items[indexPath.item].list[currentIndex].main.temp - 273))")
    cell.weatherDescriptionLabel.text = String("\(self.items[indexPath.item].list[currentIndex].weather[0].weatherDescription)")
    cell.iconImageView.image = UIImage(named: self.items[indexPath.item].list[currentIndex].weather[0].icon)
  }
  
  func setUpEveryHours(_ cell: WeatherCollectionViewCell,
                         indexPath: IndexPath) {
    // highligh button if button is checking
    cell.everyHoursButton.layer.backgroundColor = #colorLiteral(red: 0, green: 0.6039215686, blue: 0.7803921569, alpha: 1)
    cell.everyDaysButton.layer.backgroundColor = #colorLiteral(red: 0, green: 0.6941176471, blue: 0.8941176471, alpha: 1)
    
    // set up detail weather every hour
    let detailEveryHour = HelperWeather.getWeatherEveryHour(data: items[indexPath.item])
    let lastedIndex = HelperWeather.getLastedIndex(data: items[indexPath.item])
    for i in 0..<6 {
      cell.dayDetailArray![i].text = detailEveryHour[i+lastedIndex]
      cell.iconDetailArray![i].image = UIImage(named: self.items[indexPath.item].list[i+lastedIndex].weather[0].icon)
    }
  }
  
  func setUpEveryDays(_ cell: WeatherCollectionViewCell,
                         indexPath: IndexPath) {
    cell.everyDaysButton.layer.backgroundColor = #colorLiteral(red: 0, green: 0.6039215686, blue: 0.7803921569, alpha: 1)
    cell.everyHoursButton.layer.backgroundColor = #colorLiteral(red: 0, green: 0.6941176471, blue: 0.8941176471, alpha: 1)
    let detailEveryDays = HelperWeather.getWeatherEveryDay(data: items[indexPath.item])
    let currentIndex = HelperWeather.getLastedIndex(data: items[indexPath.item]) + 1
    for i in 0..<6 {
      // [list] in JSON has 40 element
      let index = i*8 + currentIndex > 39 ? 39 : i*8 + currentIndex
      cell.dayDetailArray![i].text = detailEveryDays[index]
      cell.iconDetailArray![i].image = UIImage(named: self.items[indexPath.item].list[index].weather[0].icon)
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
  
  func setUpLineChartViewForEveryDays(_ cell: WeatherCollectionViewCell, indexPath: IndexPath) {
    var values: [Double] = []
    let lastedIndex = HelperWeather.getLastedIndex(data: items[indexPath.item])
    for i in 0..<6 {
      // change temperature to Integer. Ex: 26.5 => 27
      let temp = Int(self.items[indexPath.item].list[i+lastedIndex].main.temp - 273)
      values.append(Double(temp))
    }
    cell.lineChartView.data = CustomLineChartView.dataChart(values: values)
    CustomLineChartView.settingChart(lineChartView: cell.lineChartView)
  }
  
  func setUpLineChartViewForEveryWeeks(_ cell: WeatherCollectionViewCell, indexPath: IndexPath) {
    var values: [Double] = []
    let currentIndex = HelperWeather.getLastedIndex(data: items[indexPath.item]) + 1
    for i in 0..<6 {
      // [list] in JSON has 40 element
      let index = i*8 + currentIndex > 39 ? 39 : i*8 + currentIndex
      let temp = Int(self.items[indexPath.item].list[index].main.temp - 273)
      values.append(Double(temp))
    }
    cell.lineChartView.data = CustomLineChartView.dataChart(values: values)
    CustomLineChartView.settingChart(lineChartView: cell.lineChartView)
  }
  
  func setUpHourNDayButton(_ cell: WeatherCollectionViewCell) {
    cell.everyHoursButton.corner()
    cell.everyHoursButton.shadow()
    cell.everyHoursButton.border()
    cell.everyDaysButton.corner()
    cell.everyDaysButton.shadow()
    cell.everyDaysButton.border()
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
      vc.selectedCityDelegate = self
      vc.deletedCityDelegate = self
    }
    else if segue.destination is AddCityViewController {
      let vc = segue.destination as! AddCityViewController
      vc.addCityDelegate = self
    }
  }
}

// MARK: - Protocol Delegate
// WeatherCollectionViewCell
extension WeatherViewController: ChangeButton {
  func isEveryDayTapped(_ isTapped: Bool) {
    isEveryDaysChecked = isTapped
    collectionView.reloadData()
  }
}

// AllCitiesTableViewController
extension WeatherViewController: SelectedCity, DeletedCity {
  func deletedCity(items: [DataStructs]) {
    self.items = items
    collectionView.reloadData()
    setUpPageControl()
  }
  
  func selectedCity(indexPath: IndexPath) {
    collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
  }
}

// AddCityViewController
extension WeatherViewController: AddCity {
  func addCity(name: String) {
    // remove space in name
    var safeName = name
    while safeName.contains(" ") {
      safeName.removeAll { (char) -> Bool in
        char == " "
      }
    }
    let dataManager = DataManager(baseURL: API.AuthenticatedBaseURL)
    dataManager.weatherDataForLocation(city: safeName) { (data, error) in
      if let _ = error {
        DispatchQueue.main.async {
          print(error!)
        }
      }
      else {
        DispatchQueue.main.async {
          self.items.append(data!)
          self.collectionView.reloadData()
          // go to new item
          let indexPath = IndexPath(item: self.items.count-1, section: 0)
          self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
          self.setUpPageControl()
          
          // when add a city, dismiss current viewcontroller and display new city in main screen
          self.dismiss(animated: true, completion: nil)
        }
      }
    }
  }
}
