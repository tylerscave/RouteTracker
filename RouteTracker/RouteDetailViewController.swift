//
//  RouteDetailViewController.swift
//  RouteTracker
//
//  Controller for the view presented when user has clicked on "Details" from
//  the route map view. This page displays the details of a single route
//
//  Created by Tyler Jones, Pete Curtis, Marshall Cargle, Matt Nowzari on 4/15/17.
//  Copyright © 2017 Front Row Crew. All rights reserved.
//

import UIKit

class RouteDetailViewController: UIViewController {

    @IBOutlet weak var dateField: UITextField!
    @IBOutlet weak var distanceField: UITextField!
    @IBOutlet weak var timeField: UITextField!
    let routes = MyRoutes.sharedInstance
    //let selectedRoute = MyRoutes.sharedInstance.selectedtRoute!
    let dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let selectedRoute = routes.selectedtRoute {
            dateFormatter.dateStyle = .long
            dateFormatter.timeStyle = .none
            dateField.text = dateFormatter.string(from: selectedRoute.startTimeStamp as Date)
            dateField.textAlignment = .center

            distanceField.text = String(format:"%f", selectedRoute.distance)
            distanceField.textAlignment = .center
        
            timeField.text = String(format:"%f", selectedRoute.endTimeStamp.timeIntervalSince(selectedRoute.startTimeStamp as Date))
            timeField.textAlignment = .center
        }
    }

}
