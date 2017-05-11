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
    
    //get the fetch request for all route
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
    
    func startRoute() {
        if (currentRoute == nil) {
            currentRoute = NSEntityDescription.insertNewObject(forEntityName: "MyRoute", into: context) as? MyRoute
            allRoutes.append(currentRoute!)
        }
    }
    
    func stopRoute() {
        if currentRoute != nil {
            currentRoute?.endTimeStamp = NSDate()
            appDelegate.saveContext()
        }
        currentRoute = nil
    }
    
    func indexOfCurrentRoute() -> Int? {
        if currentRoute != nil {
            return allRoutes.index(of: currentRoute!)
        }
        return nil
    }
    
    // MARK: - Core Data stack
    
    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file.
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1] as NSURL
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. 
        //  It is a fatal error for the application not to be able to find and load its model.
        let modelURL = Bundle.main.url(forResource: "RouteTracker", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
}

