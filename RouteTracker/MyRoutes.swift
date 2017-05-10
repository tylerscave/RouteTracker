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

private let _MyRoutesSharedInstance = MyRoutes()
@objc(Route)
class MyRoutes: NSObject{
    
    // Singleton instance - Trying this for dealing with core data
    class var sharedInstance: MyRoutes {
        return _MyRoutesSharedInstance
    }
    
    var currentRoute: Route?
    
    //get the fetch request for all route
    lazy var allRoutes: [Route] = {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Route")
        let sortDescriptor = NSSortDescriptor(key: "startTimestamp", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        //original request line
//        if let fetchResults = self.managedObjectContext!.executeFetchRequest(fetchRequest, error: nil) as? [Route] {
//        if let fetchResults = try self.managedObjectContext!.fetch(fetchRequest) as? [Route] {
        do{
        if let fetchResults = try context.fetch(fetchRequest) as? [Route] {
            //test print to see values
            print("StartTime: \(fetchResults[0].startTimestamp)\nEndTime: \(fetchResults[0].endTimestamp)")
            return fetchResults
            }
        } catch{
            fatalError("Failed to fetch Routes: \(error)")
        }
    return [Route]()
        
        //needs a try
//        let moc : self.managedObjectContext
//        var fetchResults : [Route]?
//        do{
//            fetchResults = try moc.fetch(fetchRequest) as? [Route]
//        }catch{
//            fatalError("Failed to fetch Routes: \(error)")
//            }
//        return fetchResults ?? [Route]()
    }()
    
    func startRoute() {
        if (currentRoute == nil) {
//            currentRoute = NSEntityDescription.insertNewObject(forEntityName: "Route", into: managedObjectContext!) as? Route
            currentRoute = NSEntityDescription.insertNewObject(forEntityName: "Route", into: context) as? Route
            allRoutes.append(currentRoute!)
        }
    }
    
    func stopRoute() {
        if currentRoute != nil {
            currentRoute?.endTimestamp = NSDate()
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
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.alpinepipeline.test" in the application's documents Application Support directory.
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1] as NSURL
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = Bundle.main.url(forResource: "RouteTracker", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    //IMPLEMENTED IN APP DELEGATE
//    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
//        // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
//        // Create the coordinator and store
//        var coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
//        let url = self.applicationDocumentsDirectory.appendingPathComponent("routetracker.sqlite")
////        var error: NSError? = nil
//        var failureReason = "There was an error creating or loading the application's saved data."
////        if coordinator!.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil, error: &error) == nil {
//       //needs a try
//        do{
//            try coordinator!.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
//        } catch{
//            coordinator = nil
//            // Report any error we got.
//            let dict = NSMutableDictionary()
//            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
//            dict[NSLocalizedFailureReasonErrorKey] = failureReason
//            dict[NSUnderlyingErrorKey] = error
//            var error = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict as [NSObject : AnyObject])
//            // Replace this with code to handle the error appropriately.
//            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//            NSLog("Unresolved error \(error), \(error.userInfo)")
//            abort()
//        }
//        return coordinator
//    }()

    
//SWIFT 1.2 VERSION
////        var managedObjectContext = NSManagedObjectContext() //Swift 1.2 version
//        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
//        managedObjectContext.persistentStoreCoordinator = coordinator
//        return managedObjectContext
//    }()


//        var managedObjectContext = NSManagedObjectContext() //Swift 1.2 version
//var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
//managedObjectContext.persistentStoreCoordinator = coordinator
//return managedObjectContext
//}()


//CONTEXT IS NOW LOCATED IN APPDELEGATE
//    lazy var managedObjectContext: NSManagedObjectContext? = {
//        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
//        let coordinator = self.persistentStoreCoordinator
//        if coordinator == nil {
//            return nil
//        }


//IMPLEMENTED IN APP DELEGATE
//    // MARK: - Core Data Saving support
//    func saveContext () {
//        do {
//            try managedObjectContext!.save()
//        } catch {
//            // Replace this implementation with code to handle the error appropriately.
//            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//            let nserror = error as NSError
//            NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
//            abort()
//        }
//        //Swift 1.2 version
////        if let moc = self.managedObjectContext {
////            var error: NSError? = nil
////            if moc.hasChanges && !moc.save(&error) {
////                // Replace this implementation with code to handle the error appropriately.
////                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
////                NSLog("Unresolved error \(error ?? <#default value#>), \(error!.userInfo)")
////                abort()
////            }
////        }
//    }
}



//ROUTE ADJUSTMENTS STEPS
//    lazy var allWalks: [Route] = {
//        //build fetch
//        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Route")
//        let sortDescriptor = NSSortDescriptor(key: "startTimestamp", ascending: true)
//        fetchRequest.sortDescriptors = [sortDescriptor]
//        //original request line
//        //        if let fetchResults = self.managedObjectContext!.executeFetchRequest(fetchRequest, error: nil) as? [Route] {
//        let moc : NSManagedObjectContext!
//        //swift site
////        var fetchedRoutes : [Route]
//        do {
//            let fetchedRoutes = try moc.fetch(fetchRequest) as! [Route]
//            return fetchedRoutes
//        } catch {
//            fatalError("Failed to fetch routes: \(error)")
//        }
//        return [Route]()
//    }

//    lazy var allWalks: [Route] = fetchRoutes()
//
//    func fetchRoutes() -> [Route]{
//        //build fetch
//        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Route")
//        let sortDescriptor = NSSortDescriptor(key: "startTimestamp", ascending: true)
//        fetchRequest.sortDescriptors = [sortDescriptor]
//        //original request line
//        //        if let fetchResults = self.managedObjectContext!.executeFetchRequest(fetchRequest, error: nil) as? [Route] {
//        let moc : NSManagedObjectContext!
//
//        //swift site
//        var fetchedRoutes : [Route]
//        do {
//            fetchedRoutes = try moc.fetch(fetchRequest) as! [Route]
//        } catch {
//            fatalError("Failed to fetch routes: \(error)")
//        }
//        return fetchedRoutes
//        }


//        more complex fetch request
//        do{
//            self.fetchResults = try! moc.fetch(fetchRequest) as? [Route]
//        } catch{ print("there was an error")}
//    return fetchResults
//simplified perform code
//        moc.perform{
//            self.fetchResults = try! fetchRequest.execute()
//        }
//}
//return [Route]()
//}()
