//
//  Weather.swift
//  
//
//  Created by Nicolas Bichon on 05/08/16.
//
//

import Foundation
import CoreData

class Weather: NSManagedObject {
    /**
     Parse a weather dictionary and create a `Weather` object.
     
     - parameter dictionary: The dictionary to parse.
     
     - returns: The optional `Weather` object.
     */
    class func parseWeather(_ dictionary: [String: AnyObject], managedObjectContext: NSManagedObjectContext) -> Weather? {
        guard let weatherArray = (dictionary["weather"] as? [[String: AnyObject]])?.first,
            let title = weatherArray["main"] as? String,
            let detail = weatherArray["description"] as? String,
            let icon = weatherArray["icon"] as? String,
            let mainArray = dictionary["main"] as? [String: AnyObject],
            let temperature = mainArray["temp"] as? Double,
            let timestamp = dictionary["dt"] as? TimeInterval,
            let cityID = dictionary["id"] as? Int,
            let cityName = dictionary["name"] as? String else {
                return nil
        }
        
        let weather = NSEntityDescription.insertNewObject(forEntityName: "Weather", into: managedObjectContext) as! Weather
        
        weather.title = title
        weather.detail = detail
        weather.icon = icon
        
        weather.temperature = NSNumber(value: temperature as Double)
        
        weather.date = Date(timeIntervalSince1970: timestamp)
        weather.isForecast = true
        
        let city = NSEntityDescription.insertNewObject(forEntityName: "City", into: managedObjectContext) as! City
        
        city.cityID = cityID as NSNumber
        city.name = cityName
        city.position = 0
        
        weather.city = city
        weather.isForecast = false
        
        return weather
    }
    
    /**
     Parse a forecast dictionary and create a `Weather` object.
     
     - parameter dictionary: The dictionary to parse.
     
     - returns: The optional `Weather` object.
     */
    class func parseForecast(_ dictionary: [String: AnyObject], managedObjectContext: NSManagedObjectContext) -> Weather? {
        guard let weatherArray = (dictionary["weather"] as? [[String: AnyObject]])?.first,
            let title = weatherArray["main"] as? String,
            let detail = weatherArray["description"] as? String,
            let icon = weatherArray["icon"] as? String,
            let tempArray = dictionary["temp"] as? [String: AnyObject],
            let temperature = tempArray["day"] as? Double,
            let timestamp = dictionary["dt"] as? TimeInterval else {
                return nil
        }
        
        let weather = NSEntityDescription.insertNewObject(forEntityName: "Weather", into: managedObjectContext) as! Weather
        
        weather.title = title
        weather.detail = detail
        weather.icon = icon
        
        weather.temperature = NSNumber(value: temperature as Double)
        
        weather.date = Date(timeIntervalSince1970: timestamp)
        weather.isForecast = true
        
        return weather
    }
    
    /**
     Remove all the weathers for a given city ID.
     
     - parameter cityID:               The city identifier.
     - parameter managedObjectContext: The `NSManagedObjectContext` object.
     */
    class func deleteForecastByCityID(_ cityID: NSNumber, managedObjectContext: NSManagedObjectContext) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Weather")
        fetchRequest.predicate = NSPredicate(format: "isForecast == 1 && city.cityID == %@", cityID)
        
        do {
            let fetchedObjects = try managedObjectContext.fetch(fetchRequest) as! [NSManagedObject]
            
            for (_, fetchedObject) in fetchedObjects.enumerated() {
                managedObjectContext.delete(fetchedObject)
            }
        } catch {
        }
    }
}
