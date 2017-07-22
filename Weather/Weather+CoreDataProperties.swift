//
//  Weather+CoreDataProperties.swift
//  
//
//  Created by Nicolas Bichon on 05/08/16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Weather {

    @NSManaged var title: String?
    @NSManaged var detail: String?
    @NSManaged var icon: String?
    @NSManaged var temperature: NSNumber?
    @NSManaged var humidity: NSNumber?
    @NSManaged var pressure: NSNumber?
    @NSManaged var minimumTemperature: NSNumber?
    @NSManaged var maximumTemperature: NSNumber?
    @NSManaged var date: Date?
    @NSManaged var isForecast: NSNumber?
    @NSManaged var city: City?

}
