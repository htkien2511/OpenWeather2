//
//  CoreDataManager.swift
//  OpenWeather2
//
//  Created by Hoang Trong Kien on 6/16/20.
//  Copyright © 2020 Hoang Trong Kien. All rights reserved.
//

import UIKit
import CoreData

class CoreDataManager {
  static let sharedManager = CoreDataManager()
  lazy var persistentContainer: NSPersistentContainer = {
    let container = NSPersistentContainer(name: "OpenWeather2")
    container.loadPersistentStores { (storeDescription, error) in
      if let error = error as NSError? {
        fatalError("Unresolved error \(error), \(error.userInfo)")
      }
    }
    return container
  }()
  var weather: [NSManagedObject] = []
}

// MARK: - Insert / Create Data
extension CoreDataManager {
  func insertWeather(id: Int, city: String, updatedDate: Date) -> WeatherGeneral? {
    let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
    let entity = NSEntityDescription.entity(forEntityName: "WeatherGeneral", in: managedContext)!
    let task = NSManagedObject(entity: entity, insertInto: managedContext)
    
    task.setValue(id, forKeyPath: "id")
    task.setValue(city, forKeyPath: "cityName")
    task.setValue(updatedDate, forKey: "updatedDate")
    
    do {
      try managedContext.save()
      return task as? WeatherGeneral
    } catch let error as NSError {
      print("Could not save. \(error), \(error.userInfo)")
      return nil
    }
  }
}

// MARK: - Fetch Data
extension CoreDataManager {
  func fetchAllWeatherCities() -> [WeatherGeneral]? {
    let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
    let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "WeatherGeneral")
    
    do {
      let weather = try managedContext.fetch(fetchRequest)
      return weather as? [WeatherGeneral]
    } catch let error as NSError {
      print("Could not fetch. \(error), \(error.userInfo)")
      return nil
    }
  }
  
  func fetchWeatherCityWith(id: Int) -> WeatherGeneral? {
    let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
    let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "WeatherGeneral")
    
    do {
      let weather = try managedContext.fetch(fetchRequest)
      for item in weather {
        if item.value(forKeyPath: "id") as? Int == id {
          return item as? WeatherGeneral
        }
      }
      return nil
    } catch let error as NSError {
      print("Could not fetch. \(error), \(error.userInfo)")
      return nil
    }
  }
}

// MARK: - Update Data
extension CoreDataManager {
  func updateWeatherCity(id: Int, newUpdatedDate: Date) -> Bool {
    let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
    let olderWeatherCity = fetchWeatherCityWith(id: id)
    
    olderWeatherCity?.setValue(newUpdatedDate, forKey: "updatedDate")
    
    do {
      try managedContext.save()
      return true
    } catch let error as NSError {
      print("Could not update. \(error), \(error.userInfo)")
      return false
    }
  }
}

// MARK: - Delete Data
extension CoreDataManager {
  
  // MARK: - Delete all cities
  func flushData() {
    let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
    let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "WeatherGeneral")
    do {
      let weatherCities = try managedContext.fetch(fetchRequest)
      for weatherCity in weatherCities {
        managedContext.delete(weatherCity)
      }
    } catch let error as NSError {
      print("Could not fetch data to flush. \(error), \(error.userInfo)")
    }
    do {
      try managedContext.save()
    } catch let error as NSError {
      print("Could not flush data. \(error), \(error.userInfo)")
    }
  }
  
  // MARK: - Delete 1 city
  func deleteWeatherCity(id: Int) -> Bool {
    let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
    guard let deletedCity = fetchWeatherCityWith(id: id) else { return false }
    
    do {
      managedContext.delete(deletedCity)
      try managedContext.save()
      return true
    } catch let error as NSError {
      print("Could not delete. \(error), \(error.userInfo)")
      return false
    }
  }
}
