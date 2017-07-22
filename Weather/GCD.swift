//
//  GCD.swift
//  Weather
//
//  Created by Nicolas Bichon on 05/08/16.
//  Copyright © 2016 Nicolas Bichon. All rights reserved.
//

import Foundation

func runOnMain(_ closure: @escaping () -> Void) {
    DispatchQueue.main.async(execute: closure)
}
