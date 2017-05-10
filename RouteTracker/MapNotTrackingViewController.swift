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

class MapNotTrackingViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {


    @IBOutlet weak var mapView: MKMapView!
    var locationManager: CLLocationManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        mapView.showsUserLocation = true
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.delegate = self
        
        //Check for Location Services
        if (CLLocationManager.locationServicesEnabled()) {
            locationManager = CLLocationManager()
            locationManager?.delegate = self
            locationManager?.desiredAccuracy = kCLLocationAccuracyBest
            locationManager?.requestAlwaysAuthorization()
            locationManager?.requestWhenInUseAuthorization()
        }
        locationManager?.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager?.startUpdatingLocation()
        }
        //Zoom to user location
        let userLocation = CLLocationCoordinate2D(latitude: (locationManager?.location?.coordinate.latitude)!, longitude: (locationManager?.location?.coordinate.longitude)!)
        let viewRegion = MKCoordinateRegionMakeWithDistance(userLocation, 3000, 3000)
        mapView.setRegion(viewRegion, animated: true)
        
        
        DispatchQueue.main.async {
            self.locationManager?.startUpdatingLocation()
        }
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

