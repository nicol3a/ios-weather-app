//
//  ForecastCellViewModel.swift
//  Weather
//
//  Created by Nicolas Bichon on 05/08/16.
//  Copyright © 2016 Nicolas Bichon. All rights reserved.
//

import Foundation

class ForecastCellViewModel: WeatherCellViewModel {
    
    // MARK - Properties
    
    fileprivate lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter
    }()
    
    // MARK: - Accessors
    
    /**
     Returns the weathers's weekday in a human-readable format.
     
     - returns: The weather's day.
     */
    func day() -> String? {
        guard let date = weather.date else {
            return nil
        }
        
        return dateFormatter.string(from: date as Date)
    }
    
    /**
     Returns the weather's title.
     
     - returns: The weather's title.
     */
    func title() -> String? {
        return weather.title
    }
    
    /**
     Returns the weather's description.
     
     - returns: The weather's description.
     */
    func description() -> String? {
        return weather.detail
    }
}
