//
//  MyRoutes.swift
//  RouteTracker
//
//  Model for MyRoutes. This is a data structure to hold all of the users saved routes
//
//  Created by Tyler Jones, Pete Curtis, Marshall Cargle, Matt Nowzari on 4/15/17.
//  Copyright © 2017 Front Row Crew. All rights reserved.
//

import Foundation
import CoreData
import CoreLocation

// Global variables for storing route information
private let _MyRoutesSharedInstance = MyRoutes()
@objc(MyRoute)

class MyRoutes: NSObject{
    
    // Singleton instance used with cord data
    class var sharedInstance: MyRoutes {
        return _MyRoutesSharedInstance
    }
    
    var currentRoute: MyRoute?
    var selectedtRoute: MyRoute?
    
    // fetch all routes from the data model
    lazy var allRoutes: [MyRoute] = {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MyRoute")
        let sortDescriptor = NSSortDescriptor(key: "startTimeStamp", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        // Try/catch to get routes
        do{
        if let fetchResults = try context.fetch(fetchRequest) as? [MyRoute] {
            return fetchResults
            }
        } catch{
            fatalError("Failed to fetch Routes: \(error)")
        }
        return [MyRoute]()
    }()
    
    // called when a new route is started
    func startRoute() {
        if (currentRoute == nil) {
            currentRoute = NSEntityDescription.insertNewObject(forEntityName: "MyRoute", into: context) as? MyRoute
            allRoutes.append(currentRoute!)
        }
    }
    
    // Called when the route is completed
    func stopRoute() {
        if currentRoute != nil {
            currentRoute?.endTimeStamp = NSDate()
            appDelegate.saveContext()
        }
        currentRoute = nil
    }
    
    // getter for the index of the current route
    func indexOfCurrentRoute() -> Int? {
        if currentRoute != nil {
            return allRoutes.index(of: currentRoute!)
        }
        return nil
    }
}

