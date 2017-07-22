//
//  City+CoreDataProperties.swift
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

extension City {

    @NSManaged var name: String?
    @NSManaged var cityID: NSNumber?
    @NSManaged var position: NSNumber?
    @NSManaged var weather: NSSet?

}
