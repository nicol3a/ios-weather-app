//
//  Constants.swift
//  Weather
//
//  Created by Nicolas Bichon on 04/08/16.
//  Copyright © 2016 Nicolas Bichon. All rights reserved.
//

import Foundation

/**
 Global constants used across the app.
 */
struct Constants {
    struct OpenWeatherMap {
        static let scheme = "http"
        static let host = "api.openweathermap.org"
        static let apiKey = "REPLACE_BY_YOUR_KEY"
    }
    
    struct City {
        static let numberOfItems = 5
        static let numberOfDays = 3
        
        struct Brussels {
            static let latitude = 50.8503
            static let longitude = 4.3517
        }
    }
    
    struct Units {
        static let fahrenheit = "imperial"
        static let celsius = "metric"
    }
    
    struct Animation {
        static let interval = 0.2
    }
}
