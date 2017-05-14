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

class MyRoute: NSManagedObject {

    @NSManaged var distance: NSNumber
    @NSManaged var startTimeStamp: NSDate
    @NSManaged var endTimeStamp: NSDate
    @NSManaged var locations: Array<CLLocation>
    
    var duration: TimeInterval {
        get { return endTimeStamp.timeIntervalSince(startTimeStamp as Date) }
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
        startTimeStamp = NSDate()
        distance = 0.0
    }
}
