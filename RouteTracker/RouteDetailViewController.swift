//
//  RouteDetailViewController.swift
//  RouteTracker
//
//  Controller for the view presented when user has clicked on the "Route Detail" tab
//  This page displays the details of a single route
//
//  Created by Tyler Jones, Pete Curtis, Marshall Cargle, Matt Nowzari on 4/15/17.
//  Copyright © 2017 Front Row Crew. All rights reserved.
//

import UIKit

class RouteDetailViewController: UIViewController {

    @IBOutlet weak var dateField: UITextField!
    @IBOutlet weak var distanceField: UITextField!
    @IBOutlet weak var timeField: UITextField!
    private let routes = MyRoutes.sharedInstance
    private let dateFormatter = DateFormatter()
    private let distanceFormatter = MeasurementFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let selectedRoute = routes.selectedtRoute {
            dateFormatter.dateStyle = .long
            dateFormatter.timeStyle = .none
            dateField.text = dateFormatter.string(from: selectedRoute.startTimeStamp as Date)
            dateField.textAlignment = .center
            
            let calculatedDistance = Measurement(value: Double(selectedRoute.distance), unit: UnitLength.feet)
            let distanceInMiles = calculatedDistance.converted(to: .miles)
            distanceField.text = distanceFormatter.string(from: distanceInMiles)
            distanceField.textAlignment = .center
        
            timeField.text = stringFromTimeInterval(interval: selectedRoute.duration) as String
            timeField.textAlignment = .center
        }
    }
    
    // helper function to calculate and format the time interval of the route
    private func stringFromTimeInterval(interval: TimeInterval) -> NSString {
        let ti = NSInteger(interval)
        let seconds = ti % 60
        let minutes = (ti / 60) % 60
        let hours = (ti / 3600)
        
        return NSString(format: "%0.2d:%0.2d:%0.2d",hours,minutes,seconds)
    }

}
