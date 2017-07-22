//
//  UnitsUtil.swift
//  Weather
//
//  Created by Nicolas Bichon on 05/08/16.
//  Copyright © 2016 Nicolas Bichon. All rights reserved.
//

import Foundation

class UnitsUtil {
    /**
     Verify if the locale uses the metric system.
     
     If the value is NO, you can typically assume American measurement units, meaning Fahrenheit, otherwise Celsius.
     
     - returns: A boolean indicating whether the locale uses the metric system or not.
     */
    class func isMetricSystem() -> Bool {
        if let localeSystem = (Locale.current as NSLocale).object(forKey: NSLocale.Key.usesMetricSystem) as? NSNumber {
            return localeSystem.boolValue
        }
        
        return (Locale.current as NSLocale).object(forKey: NSLocale.Key.usesMetricSystem) as! Bool
    }
}
