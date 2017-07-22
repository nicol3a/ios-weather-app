//
//  Error.swift
//  Weather
//
//  Created by Nicolas Bichon on 05/08/16.
//  Copyright © 2016 Nicolas Bichon. All rights reserved.
//

import UIKit

protocol Error {
    func errorCode() -> Int
    func description() -> String
}

func !=(left: Error, right: Error) -> Bool {
    return !(left.errorCode() == right.errorCode())
}
