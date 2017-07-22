//
//  State.swift
//  Weather
//
//  Created by Nicolas Bichon on 05/08/16.
//  Copyright © 2016 Nicolas Bichon. All rights reserved.
//

import Foundation

/**
 State of a fetch, mostly used in View Models.
 */
enum State: Equatable {
    case initial
    case loading
    case completed
    case cancelled
    case failed(Error)
}

/**
 Comparison method, necessary to be able to compare two `Failed` cases.
 
 - parameter left: The error to compare.
 - parameter right: The error to compared to.
 - returns: A boolean indicating whether the values are equal or not.
 */
func ==(left: State, right: State) -> Bool {
    switch (left, right) {
    case (.initial, .initial):
        return true
    case (.loading, .loading):
        return true
    case (.completed, .completed):
        return true
    case (.cancelled, .cancelled):
        return true
    case (.failed(let errorLeft), . failed(let errorRight)) where errorLeft.errorCode() == errorRight.errorCode():
        return true
    default:
        return false
    }
}
