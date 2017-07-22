//
//  NetworkIndicator.swift
//  Weather
//
//  Created by Nicolas Bichon on 05/08/16.
//  Copyright © 2016 Nicolas Bichon. All rights reserved.
//

import UIKit

/// Used to show / hide network activity indicator
class NetworkIndicator {
    class func startNetworkActivity() {
        self.setNetworkActivity(true)
    }
    
    class func stopNetworkActivity() {
        self.setNetworkActivity(false)
    }
    
    fileprivate class func setNetworkActivity(_ active: Bool) {
        runOnMain {
            UIApplication.shared.isNetworkActivityIndicatorVisible = active
        }
    }
}
