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

class SavedRouteListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    let dateFormatter = DateFormatter()
    var deleteRouteIndexPath: NSIndexPath? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .short
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }

    //return a cell row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell")!

        let allRoutes = MyRoutes.sharedInstance.allRoutes
        let selectedRoute = allRoutes[indexPath.row]
        cell.textLabel?.text = dateFormatter.string(from: selectedRoute.startTimeStamp as Date)
            
        return cell
    }
    
    //index of each cell
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MyRoutes.sharedInstance.allRoutes.count
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let allRoutes = MyRoutes.sharedInstance.allRoutes
        let route = allRoutes[indexPath.row] as MyRoute
        MyRoutes.sharedInstance.selectedtRoute = route
        self.dismiss(animated: true, completion: nil)
    }
    
    // this method handles row deletion
    //used from http://stackoverflow.com/questions/3309484/uitableviewcell-show-delete-button-on-swipe/37719543#37719543
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        let allRoutes = MyRoutes.sharedInstance.allRoutes
        if editingStyle == .delete {
            
            // remove the item from the data model
            deleteRouteIndexPath = indexPath as NSIndexPath
//            let routeToDelete = allRoutes[indexPath.row]
//            confirmDelete(routeToRemove: routeToDelete)
            confirmDelete()
//            animals.remove(at: indexPath.row)
            
            // delete the table view row
//            tableView.deleteRows(at: [indexPath], with: .fade)
            
//        } else if editingStyle == .insert {
            // Not used in our example, but if you were adding a new row, this is where you would do it.
        }
    }
    
//    func confirmDelete(routeToRemove :MyRoute){
    func confirmDelete(){
        let alert = UIAlertController(title: "Delete Route", message: "Do you want to delete this route?", preferredStyle: .actionSheet)
        
//        let saveAction = UIAlertAction(title: "Save", style: .destructive) { (alert: UIAlertAction!) -> Void in
            let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: handleDeleteRoute)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: cancelDeleteRoute)
        
            alert.addAction(deleteAction)
            alert.addAction(cancelAction)
        
            self.present(alert, animated: true, completion:nil)
    }
    
    func handleDeleteRoute(alertAction: UIAlertAction!) -> Void {
        var allRoutes = MyRoutes.sharedInstance.allRoutes
        if let indexPath = deleteRouteIndexPath {
            tableView.beginUpdates()
            
            allRoutes.remove(at: indexPath.row)
            
            // Note that indexPath is wrapped in an array:  [indexPath]
            tableView.deleteRows(at: [indexPath as IndexPath], with: .automatic)
            
            deleteRouteIndexPath = nil
            
            tableView.endUpdates()
        }
    }
    
    func cancelDeleteRoute(alertAction: UIAlertAction!) {
        deleteRouteIndexPath = nil
    }

}
