//
//  ParseForecastService.swift
//  Weather
//
//  Created by Nicolas Bichon on 05/08/16.
//  Copyright © 2016 Nicolas Bichon. All rights reserved.
//

import Foundation
import CoreData

class ParseForecastService: ParseService {
    var managedObjectContext: NSManagedObjectContext

    init(managedObjectContext: NSManagedObjectContext) {
        self.managedObjectContext = managedObjectContext
    }

    /**
     Parses the response from the server.

     It also deletes all the forecast weathers for the currenyt city, before inserting the new ones.

     - parameter dictionary: The weather list dictionary.
     */
    func parseForecastListFor(_ city: City, dictionary: [String: AnyObject], success: Success, failure: @escaping Failure) {
        guard let forecastListDictionary = dictionary["list"] as? [[String: AnyObject]] else {
            failure(ServiceError.parsingError)
            return
        }

        deleteAllForecastsFor(city)

        var weathers = [Weather]()

        for (_, forecastDictionary) in forecastListDictionary.enumerated() {
            let weather = Weather.parseForecast(forecastDictionary, managedObjectContext: managedObjectContext)
            weather?.city = city

            weathers.append(weather!)
        }

        do {
            try managedObjectContext.save()

            success(weathers)
        } catch {
            failure(ServiceError.storageError)
        }
    }

    fileprivate func deleteAllForecastsFor(_ city: City) {
        Weather.deleteForecastByCityID(city.cityID!, managedObjectContext: managedObjectContext)
    }
}
