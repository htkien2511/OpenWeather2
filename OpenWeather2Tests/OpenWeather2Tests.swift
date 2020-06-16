//
//  OpenWeather2Tests.swift
//  OpenWeather2Tests
//
//  Created by Hoang Trong Kien on 6/15/20.
//  Copyright © 2020 Hoang Trong Kien. All rights reserved.
//

import XCTest
import CoreData
@testable import OpenWeather2

class OpenWeather2Tests: XCTestCase {
  
  var coreDataManager: CoreDataManager!
  
  override func setUpWithError() throws {
    super.setUp()
    coreDataManager = CoreDataManager.sharedManager
  }
  
  override func tearDownWithError() throws {
    super.tearDown()
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }
  
  // MARK: - Our test case
  func test_init_coreDataManager() {
    let instance = CoreDataManager.sharedManager
    XCTAssertNotNil(instance)
  }
  
  func test_coreDataStackInitialization() {
    let coreDataStack = CoreDataManager.sharedManager.persistentContainer
    XCTAssertNotNil(coreDataStack)
  }
  
  func test_create_weather() {
    //    let dataManager = DataManager.init(baseURL: API.AuthenticatedBaseURL)
    //    dataManager.weatherDataForLocation(city: "DaNang") { (data, error) in
    //      print(data)
    //      let id = data!.city.id
    //      let cityName = data!.city.name
    //      let date = Date()
    //      print("1223123123")
    //      let weather = self.coreDataManager.insertWeather(id: id, city: cityName, updatedDate: date)
    //      XCTAssertNotNil(weather)
    //      print(weather)
    //    }
    let date = Date()
    let weather = self.coreDataManager.insertWeather(id: 12345, city: "test City", updatedDate: date)
    XCTAssertNotNil(weather)
  }
  
  func test_fetch_all_weather() {
    let weather = coreDataManager.fetchAllWeatherCities()
    print("begin")
    for item in weather! {
      print(item.id)
      print(item.cityName!)
      print(item.updatedDate!)
    }
    print("end")
    XCTAssertEqual(weather?.count, 2)
  }
  
  func test_fetch_weather_city_with_id() {
    let id = 12345
    let weather = coreDataManager.fetchWeatherCityWith(id: id)
    XCTAssertNotNil(weather)
  }
  
  func test_update_weather_city_with_id() {
    let id = 12345
    let newDate = Date()
    
    let updateSucess = coreDataManager.updateWeatherCity(id: id, newUpdatedDate: newDate)
    XCTAssertTrue(updateSucess)
    
    let updatedWeather = coreDataManager.fetchWeatherCityWith(id: id)
    XCTAssertEqual(updatedWeather!.updatedDate, newDate)
  }
  
  func test_delete_weather_city_with_id() {
    let id = 12345
    
    let weatherCities = coreDataManager.fetchAllWeatherCities()
    let numberOfCities = weatherCities?.count
    
    let deleteSuccess = coreDataManager.deleteWeatherCity(id: id)
    
    XCTAssertTrue(deleteSuccess)
    XCTAssertEqual(coreDataManager.fetchAllWeatherCities()?.count, numberOfCities! - 1)
  }
  
  func test_flush_data_weather() {
    coreDataManager.flushData()
    XCTAssertEqual(coreDataManager.fetchAllWeatherCities()?.count, 0)
  }
}
