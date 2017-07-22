//
//  City.swift
//  
//
//  Created by Nicolas Bichon on 05/08/16.
//
//

import Foundation
import CoreData

class City: NSManagedObject {
    /**
     Delete all the cities, which also deletes all the weathers associated.
     
     - parameter managedObjectContext: The `NSManagedObjectContext` object.
     */
    class func deleteAll(_ managedObjectContext: NSManagedObjectContext) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "City")
        
        do {
            let fetchedObjects = try managedObjectContext.fetch(fetchRequest) as! [NSManagedObject]
            
            for (_, fetchedObject) in fetchedObjects.enumerated() {
                managedObjectContext.delete(fetchedObject)
            }
        } catch {
        }
    }
}
