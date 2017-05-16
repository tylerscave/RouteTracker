//
//  Route.swift
//  RouteTracker
//
//  Model for the Route object. The route object represents a single route
//  This class is tied to the CoreData entity "myRoute"
//
//  Created by Tyler Jones, Pete Curtis, Marshall Cargle, Matt Nowzari on 4/15/17.
//  Copyright © 2017 Front Row Crew. All rights reserved.
//

import Foundation
import CoreData
import CoreLocation

class MyRoute: NSManagedObject {

    // attributes of a route
    @NSManaged var distance: NSNumber
    @NSManaged var startTimeStamp: NSDate
    @NSManaged var endTimeStamp: NSDate
    @NSManaged var locations: Array<CLLocation>
    
    // function to get the duration of the route
    var duration: TimeInterval {
        get { return endTimeStamp.timeIntervalSince(startTimeStamp as Date) }
    }
    
    // function to add distance to the route as the user moves
    func addDistance(distance: Double) {
        self.distance = NSNumber(value: (self.distance.doubleValue + distance))
    }
    
    // functions that adds new locations to the route as the user moves
    func addNewLocation(location: CLLocation) {
        locations.append(location)
    }
    
    // called when a new route is created
    override func awakeFromInsert() {
        super.awakeFromInsert()
        
        locations = [CLLocation]()
        startTimeStamp = NSDate()
        distance = 0.0
    }
}
