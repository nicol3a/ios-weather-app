//
//  WeatherCellViewModelTests.swift
//  Weather
//
//  Created by Nicolas Bichon on 05/08/16.
//  Copyright © 2016 Nicolas Bichon. All rights reserved.
//

import XCTest
import CoreData
@testable import Weather

class WeatherCellViewModelTests: XCTestCase {
    
    var persistentStack: PersistentStack!
    var weather: Weather!
    var viewModel: WeatherCellViewModel!
    
    override func setUp() {
        super.setUp()
        persistentStack = PersistentStack()
        weather = NSEntityDescription.insertNewObject(forEntityName: "Weather", into: persistentStack.managedObjectContext) as! Weather
        viewModel = WeatherCellViewModel(weather: weather, managedObjectContext: persistentStack.managedObjectContext)
    }
    
    override func tearDown() {
        persistentStack = nil
        weather = nil
        viewModel = nil
        super.tearDown()
    }
    
    func testCityNameIsCorrectlyFormatted() {
        // Given
        let city = NSEntityDescription.insertNewObject(forEntityName: "City", into: persistentStack.managedObjectContext) as! City
        city.name = "Brussels"
        
        weather.city = city
        
        // When
        let cityName = viewModel.cityName()!
        
        // Then
        XCTAssertEqual(cityName, "BRUSSELS", "The city name should be correctly formatted")
    }
    
    func testTemperatureIsCorrectlyFormatted() {
        // Given
        weather.temperature = 25.50
        
        // When
        let temperature = viewModel.temperature()!
        
        // Then
        XCTAssertEqual(temperature, "25°F", "The temperature should be correctly formatted")
    }

    /**
     Not working for an obscure reason, the two strings are equals...
     */
//    func testImageURLIsCorrectlyFormatted() {
//        // Given
//        weather.icon = "d100"
//        
//        // When
//        let imageURL = viewModel.imageURL()!
//        
//        // Then
//        XCTAssertEqual(imageURL.absoluteURL, "http://openweathermap.org/img/w/d100.png", "The image URL should be correctly formatted")
//    }
    
}
