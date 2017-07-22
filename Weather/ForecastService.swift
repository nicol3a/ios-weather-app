//
//  ForecastService.swift
//  Weather
//
//  Created by Nicolas Bichon on 05/08/16.
//  Copyright © 2016 Nicolas Bichon. All rights reserved.
//

import Foundation
import CoreData

/// Service that download the forecast for a city
class ForecastService {
    typealias Success = (([NSManagedObject]) -> Void)
    typealias Failure = ((Error) -> Void)

    var managedObjectContext: NSManagedObjectContext

    init(managedObjectContext: NSManagedObjectContext) {
        self.managedObjectContext = managedObjectContext
    }

    func downloadForecastListBy(_ city: City, count: Int, success: @escaping Success, failure: @escaping Failure) {
        DownloadForecastService().downloadForecastListByCityID(
            city.cityID!.intValue,
            count: count,
            success: { response in
                self.parseForecastListFor(city, dictionary: response, success: success, failure: failure)
            }, failure: { error in
                failure(error)
            }
        )
    }

    func parseForecastListFor(_ city: City, dictionary: [String: AnyObject], success: @escaping Success, failure: @escaping Failure) {
        ParseForecastService(managedObjectContext: managedObjectContext).parseForecastListFor(
            city,
            dictionary: dictionary,
            success: { weathers in
                success(weathers)
            },
            failure: { error in
                failure(error)
            }
        )
    }
}
