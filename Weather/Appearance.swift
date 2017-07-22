//
//  Appearance.swift
//  Weather
//
//  Created by Nicolas Bichon on 05/08/16.
//  Copyright © 2016 Nicolas Bichon. All rights reserved.
//

import UIKit

class Appearance {
    class func setupAppearance() {
        self.setupNavigationBarAppearance()
    }
    
    /**
     Customize the navigation bar fonts (title and UIBarButtonItem labels)
     */
    fileprivate class func setupNavigationBarAppearance() {
        let bodySize = UIFontDescriptor.preferredFontDescriptor(withTextStyle: UIFontTextStyle.body).pointSize
        
        UINavigationBar.appearance().titleTextAttributes = [
            NSFontAttributeName: UIFont(name: "Avenir-Heavy", size: bodySize)!
        ]
        UIBarButtonItem.appearance().setTitleTextAttributes(
            [
                NSFontAttributeName: UIFont(name: "Avenir", size: bodySize)!
            ],
            for: UIControlState()
        )
    }
}
