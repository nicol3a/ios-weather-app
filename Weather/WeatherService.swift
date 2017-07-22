//
//  WeatherService.swift
//  Weather
//
//  Created by Nicolas Bichon on 05/08/16.
//  Copyright © 2016 Nicolas Bichon. All rights reserved.
//

import Foundation
import CoreData

/// Service that downloads the weather for the closest cities around a GPS coordinates.
class WeatherService {
    typealias Success = (([NSManagedObject]) -> Void)
    typealias Failure = ((Error) -> Void)

    var managedObjectContext: NSManagedObjectContext

    init(managedObjectContext: NSManagedObjectContext) {
        self.managedObjectContext = managedObjectContext
    }

    func downloadWeatherListByCoordinates(_ latitude: Double, longitude: Double, count: Int, success: @escaping Success, failure: @escaping Failure) {
        DownloadWeatherService().downloadWeatherListByCoordinates(
            latitude,
            longitude: longitude,
            count: count,
            success: { response in
                self.parseWeatherList(response, success: success, failure: failure)
            }, failure: { error in
                failure(error)
            }
        )
    }

    func parseWeatherList(_ dictionary: [String: AnyObject], success: @escaping Success, failure: @escaping Failure) {
        ParseWeatherService(managedObjectContext: managedObjectContext).parseWeatherList(
            dictionary,
            success: { weathers in
                success(weathers)
            },
            failure: { error in
                failure(error)
            }
        )
    }
}
