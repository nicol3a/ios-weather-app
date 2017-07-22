//
//  DownloadService.swift
//  Weather
//
//  Created by Nicolas Bichon on 05/08/16.
//  Copyright © 2016 Nicolas Bichon. All rights reserved.
//

import Foundation

class DownloadService {
    typealias Response = [String: AnyObject]
    typealias Success = ((Response) -> Void)
    typealias Failure = ((Error) -> Void)
    
    var urlComponents = URLComponents()
    
    fileprivate let unitsKey = "units"
    fileprivate let languageKey = "lang"
    fileprivate let appIDKey = "appid"
    
    init() {
        urlComponents.scheme = Constants.OpenWeatherMap.scheme
        urlComponents.host = Constants.OpenWeatherMap.host
    }
    
    /**
     Create a URL for the API, with the basic components.
     
     Each URL contains:
     - the current unit,
     - the language,
     - the app ID.
     
     - parameter path:       The path of the URL.
     - parameter parameters: The parameters of the URL.
     
     - returns: An `NSURL` object.
     */
    func createURLWithComponents(_ path: String, parameters: [String: String]) -> URL? {
        urlComponents.path = path
        
        // Transform parameters in `NSURLQueryItem` objects
        var queryItems = parameters.flatMap { URLQueryItem(name: $0.0, value: $0.1) }
        
        // Add units
        queryItems.append(unitsQuery())
        
        // Add language
        if let languageQuery = languageQuery() {
            queryItems.append(languageQuery)
        }
        
        // Add app ID key
        queryItems.append(appIDQuery())
        
        urlComponents.queryItems = queryItems
        
        return urlComponents.url
    }
    
    // MARK: - Convenience
    
    fileprivate func unitsQuery() -> URLQueryItem {
        let units = UnitsUtil.isMetricSystem() ? Constants.Units.celsius : Constants.Units.fahrenheit
        return URLQueryItem(name: unitsKey, value: units)
    }
    
    fileprivate func languageQuery() -> URLQueryItem? {
        guard let language = LanguageUtil.currentLanguage() else {
            return nil
        }
        
        return URLQueryItem(name: languageKey, value: language)
    }
    
    fileprivate func appIDQuery() -> URLQueryItem {
        return URLQueryItem(name: appIDKey, value: Constants.OpenWeatherMap.apiKey)
    }
}
