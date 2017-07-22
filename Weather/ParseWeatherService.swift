//
//  ParseWeatherService.swift
//  Weather
//
//  Created by Nicolas Bichon on 05/08/16.
//  Copyright © 2016 Nicolas Bichon. All rights reserved.
//

import Foundation
import CoreData

class ParseWeatherService: ParseService {
    var managedObjectContext: NSManagedObjectContext

    init(managedObjectContext: NSManagedObjectContext) {
        self.managedObjectContext = managedObjectContext
    }

    /**
     Parses the response from the server.

     It also deletes all the previous cities, before inserting the new ones.

     - parameter dictionary: The weather list dictionary.
     */
    func parseWeatherList(_ dictionary: [String: AnyObject], success: Success, failure: @escaping Failure) {
        guard let weatherListDictionary = dictionary["list"] as? [[String: AnyObject]] else {
            failure(ServiceError.parsingError)
            return
        }

        deleteAllCities()

        var weathers = [Weather]()

        for (index, weatherDictionary) in weatherListDictionary.enumerated() {
            let weather = Weather.parseWeather(weatherDictionary, managedObjectContext: managedObjectContext)
            weather?.city?.position = NSNumber(value: index)

            weathers.append(weather!)
        }

        do {
            try managedObjectContext.save()

            success(weathers)
        } catch {
            failure(ServiceError.storageError)
        }
    }

    fileprivate func deleteAllCities() {
        City.deleteAll(managedObjectContext)
    }
}
