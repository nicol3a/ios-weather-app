//
//  ServiceError.swift
//  Weather
//
//  Created by Nicolas Bichon on 05/08/16.
//  Copyright © 2016 Nicolas Bichon. All rights reserved.
//

import UIKit

enum ServiceError: Int, Error {
    case noInternetConnection
    case parsingError
    case storageError
    case unknownError
    
    init(errorCode: Int) {
        switch errorCode {
        case NSURLErrorNotConnectedToInternet:
            self = .noInternetConnection
        default:
            self = .unknownError
        }
    }
    
    func errorCode() -> Int {
        switch self {
        case .noInternetConnection:
            return NSURLErrorNotConnectedToInternet
        default:
            return self.rawValue
        }
    }
    
    func description() -> String {
        switch self {
        case .noInternetConnection:
            return NSLocalizedString("No Internet connection. Please review your connection.", comment: "")
        case .parsingError:
            return NSLocalizedString("Invalid server response.", comment: "")
        case .storageError:
            return NSLocalizedString("The data cannot be saved.", comment: "")
        default:
            return NSLocalizedString("An error has occured.", comment: "")
        }
    }
}
