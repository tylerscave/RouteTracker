//
//  Route.swift
//  RouteTracker
//
//  Model for the Route object. The route object represents a single route
//
//  Created by Tyler Jones, Pete Curtis, Marshall Cargle, Matt Nowzari on 4/15/17.
//  Copyright © 2017 Front Row Crew. All rights reserved.
//

import Foundation
import CoreData
import CoreLocation

class Route: NSManagedObject {
   // TODO 
    @NSManaged var distance: NSNumber
    @NSManaged var startTimestamp: NSDate
    @NSManaged var endTimestamp: NSDate
    @NSManaged var locations: Array<CLLocation>
    
    var duration: TimeInterval {
        get {
            return endTimestamp.timeIntervalSince(startTimestamp as Date)
        }
    }
    
    func addDistance(distance: Double) {
        self.distance = NSNumber(value: (self.distance.doubleValue + distance))
    }
    
    func addNewLocation(location: CLLocation) {
        locations.append(location)
    }
    
    override func awakeFromInsert() {
        super.awakeFromInsert()
        
        locations = [CLLocation]()
        startTimestamp = NSDate()
        distance = 0.0
    }
    
}
