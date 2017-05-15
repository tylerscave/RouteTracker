//
//  SavedRouteListViewController.swift
//  RouteTracker
//
//  Controller for the view presented when user has either saved a route,
//  or clicked on "Routes" from the main menu. The view shows a list of
//  the users saved routes
//
//  Created by Tyler Jones, Pete Curtis, Marshall Cargle, Matt Nowzari on 4/15/17.
//  Copyright © 2017 Front Row Crew. All rights reserved.
//

import UIKit
import Foundation
import CoreData

class SavedRouteListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    let dateFormatter = DateFormatter()
    var deleteRouteIndexPath: NSIndexPath? = nil
    var myRoutes = MyRoutes.sharedInstance.allRoutes
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .short
        myRoutes = MyRoutes.sharedInstance.allRoutes
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }

    // create cells containing the routes and populate the table
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell")!
        let selectedRoute = myRoutes[indexPath.row]
        cell.textLabel?.text = dateFormatter.string(from: selectedRoute.startTimeStamp as Date)
            
        return cell
    }
    
    // number of routes in table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myRoutes.count
    }
    
    // runs when a cell is selected
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let route = myRoutes[indexPath.row] as MyRoute
        MyRoutes.sharedInstance.selectedtRoute = route
        self.dismiss(animated: true, completion: nil)
    }

    // delete a route swiping left
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let myRoute = myRoutes[indexPath.row]
        if editingStyle == .delete {
            context.delete(myRoute)
            myRoutes.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
            do {
                try context.save()
            } catch let error as NSError {
                print("Error While Deleting Route: \(error.userInfo)")
            }
        }
        self.tableView.reloadData()
    }
}
