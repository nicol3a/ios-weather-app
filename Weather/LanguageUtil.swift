//
//  LanguageUtil.swift
//  Weather
//
//  Created by Nicolas Bichon on 05/08/16.
//  Copyright © 2016 Nicolas Bichon. All rights reserved.
//

import UIKit

class LanguageUtil {
    /**
     Returns the current language of the device.
     
     - returns: The current language
     */
    static func currentLanguage() -> String? {
        return (Locale.current as NSLocale).object(forKey: NSLocale.Key.languageCode) as? String
    }
}
