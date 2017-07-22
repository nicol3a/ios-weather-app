//
//  DownloadWeatherService.swift
//  Weather
//
//  Created by Nicolas Bichon on 05/08/16.
//  Copyright © 2016 Nicolas Bichon. All rights reserved.
//

import Foundation

/// Service that downloads the weather for the closest cities around a GPS coordinates.
class DownloadWeatherService: DownloadService {
    fileprivate let path = "/data/2.5/find"

    fileprivate let latitudeKey = "lat"
    fileprivate let longitudeKey = "lon"
    fileprivate let countKey = "cnt"

    func downloadWeatherListByCoordinates(_ latitude: Double, longitude: Double, count: Int, success: @escaping Success, failure: @escaping Failure) {
        guard let url = createWeatherURLWithComponents(latitude, longitude: longitude, count: count) else {
            return
        }

        HTTPClient().performRequest(
            .get,
            url: url,
            success: { data in
                guard let response = data as? Response else {
                    failure(ServiceError.parsingError)
                    return
                }

                success(response)
            }, failure: { error in
                failure(error)
            }
        )
    }

    fileprivate func createWeatherURLWithComponents(_ latitude: Double, longitude: Double, count: Int) -> URL? {
        let paramaters: [String: String] = [
            latitudeKey: "\(latitude)",
            longitudeKey: "\(longitude)",
            countKey: "\(count)"
        ]

        return createURLWithComponents(path, parameters: paramaters)
    }
}
