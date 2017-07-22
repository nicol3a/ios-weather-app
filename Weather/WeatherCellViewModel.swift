//
//  WeatherCellViewModel.swift
//  Weather
//
//  Created by Nicolas Bichon on 05/08/16.
//  Copyright © 2016 Nicolas Bichon. All rights reserved.
//

import Foundation
import CoreData

class WeatherCellViewModel {
    
    // MARK: - Properties
    
    fileprivate(set) var managedObjectContext: NSManagedObjectContext
    fileprivate(set) var weather: Weather

    // MARK: - Lifetime
    
    init(weather: Weather, managedObjectContext: NSManagedObjectContext) {
        self.weather = weather
        self.managedObjectContext = managedObjectContext
    }
    
    // MARK: - Accessors
    
    func cityName() -> String? {
        return weather.city?.name?.uppercased()
    }
    
    /**
     Returns the rounded temperature.
     
     - returns: The temperature.
     */
    func temperature() -> String? {
        guard let temperature = weather.temperature else {
            return nil
        }
        
        let unit = UnitsUtil.isMetricSystem() ? "°C" : "°F"
        
        return "\(temperature.intValue)\(unit)"
    }
    
    /**
     Returns the image URL corresponding to the weather.
     
     - returns: The image URL.
     */
    func imageURL() -> URL? {
        guard let icon = weather.icon else {
            return nil
        }
        
        return URL(string: "http://openweathermap.org/img/w/\(icon).png")
    }
}
