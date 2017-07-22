//
//  DownloadForecastService.swift
//  Weather
//
//  Created by Nicolas Bichon on 05/08/16.
//  Copyright © 2016 Nicolas Bichon. All rights reserved.
//

import Foundation

/// Service that download the forecast for a city
class DownloadForecastService: DownloadService {
    fileprivate let path = "/data/2.5/forecast/daily"

    fileprivate let cityIDKey = "id"
    fileprivate let countKey = "cnt"

    func downloadForecastListByCityID(_ cityID: Int, count: Int, success: @escaping Success, failure: @escaping Failure) {
        guard let url = createForecastURLWithComponents(cityID, count: count) else {
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

    fileprivate func createForecastURLWithComponents(_ cityID: Int, count: Int) -> URL? {
        let paramaters: [String: String] = [
            cityIDKey: "\(cityID)",
            countKey: "\(count)"
        ]

        return createURLWithComponents(path, parameters: paramaters)
    }
}
