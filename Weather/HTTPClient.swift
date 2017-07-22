//
//  HTTPClient.swift
//  Weather
//
//  Created by Nicolas Bichon on 05/08/16.
//  Copyright © 2016 Nicolas Bichon. All rights reserved.
//

import Foundation
import Alamofire

class HTTPClient {
    typealias Success = ((AnyObject?) -> Void)
    typealias Failure = ((Error) -> Void)
    
    func performRequest(_ method: Alamofire.HTTPMethod, url: URL, success: @escaping Success, failure: @escaping Failure) {
        Alamofire.request(url.absoluteString, method: method)
            .validate(statusCode: 200 ..< 300)
            .responseJSON { response in
                switch response.result {
                case .success(let data):
                    // Check status between 200 and 204
                    guard let statusCode = response.response?.statusCode, 200 ... 204 ~= statusCode else {
                        failure(ServiceError.unknownError)
                        return
                    }
                    
                    success(data as AnyObject)
                case .failure(let error):
                    if (error as NSError).domain == NSURLErrorDomain && ((error as NSError).code == NSURLErrorNetworkConnectionLost || (error as NSError).code == NSURLErrorNotConnectedToInternet) {
                        failure(ServiceError.noInternetConnection)
                    } else {
                        failure(ServiceError.unknownError)
                    }
                }
        }
    }
}
