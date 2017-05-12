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

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell")!

        let allRoutes = MyRoutes.sharedInstance.allRoutes
        let route = allRoutes[indexPath.row]
        cell.textLabel?.text = dateFormatter.string(from: route.startTimeStamp as Date)
            
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MyRoutes.sharedInstance.allRoutes.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let allRoutes = MyRoutes.sharedInstance.allRoutes
        let route = allRoutes[indexPath.row] as MyRoute
        MyRoutes.sharedInstance.selectedtRoute = route
        self.dismiss(animated: true, completion: nil)
    }
}
