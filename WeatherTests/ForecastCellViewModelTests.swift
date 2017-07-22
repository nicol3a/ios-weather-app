//
//  ForecastCellViewModelTests.swift
//  Weather
//
//  Created by Nicolas Bichon on 05/08/16.
//  Copyright © 2016 Nicolas Bichon. All rights reserved.
//

import XCTest
import CoreData
@testable import Weather

class ForecastCellViewModelTests: XCTestCase {
    
    var persistentStack: PersistentStack!
    var weather: Weather!
    var viewModel: ForecastCellViewModel!
    
    override func setUp() {
        super.setUp()
        persistentStack = PersistentStack()
        weather = NSEntityDescription.insertNewObject(forEntityName: "Weather", into: persistentStack.managedObjectContext) as! Weather
        viewModel = ForecastCellViewModel(weather: weather, managedObjectContext: persistentStack.managedObjectContext)
    }
    
    override func tearDown() {
        persistentStack = nil
        weather = nil
        viewModel = nil
        super.tearDown()
    }
    
    func testWeatherDateIsCorrectlyFormatted() {
        // Given
        weather.date = Date(timeIntervalSince1970: 1470384000) // 05/08/15 11:00:00
        
        // When
        let day = viewModel.day()!
        
        // Then
        XCTAssertEqual(day, "Friday", "The day should be correctly formatted")
    }
    
    func testWeatherTitleIsCorrectlyFormatted() {
        // Given
        weather.title = "Clouds"
        
        // When
        let title = viewModel.title()
        
        // Then
        XCTAssertEqual(title, "Clouds", "The title should be correctly formatted")
    }
    
    func testWeatherDescriptionIsCorrectlyFormatted() {
        // Given
        weather.detail = "scattered clouds"
        
        // When
        let description = viewModel.description()
        
        // Then
        XCTAssertEqual(description, "scattered clouds", "The description should be correctly formatted")
    }
    
}
