//
//  MapNotTrackingViewController.swift
//  RouteTracker
//
//  Controller for the map view presented when user has not yet started
//  recording their route. This is the first page in the navigation
//
//  Created by Tyler Jones, Pete Curtis, Marshall Cargle, Matt Nowzari on 4/15/17.
//  Copyright © 2017 Front Row Crew. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapNotTrackingViewController: UIViewController, CLLocationManagerDelegate {


    
    var locationManager:CLLocationManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager = CLLocationManager()
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.delegate = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    private func zoomOnUser(userLocation: CLLocation) {
    


}

