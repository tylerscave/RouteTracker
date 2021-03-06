//
//  MapTrackingViewController.swift
//  RouteTracker
//
//  Controller for the map view. This is the main functionality of the app. This screen
//  is where the user starts and stops tracking a route.
//
//  Created by Tyler Jones, Pete Curtis, Marshall Cargle, Matt Nowzari on 4/15/17.
//  Copyright © 2017 Front Row Crew. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import CoreData

class MapTrackingViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    private var tracking = false;
    private var locationManager:CLLocationManager?
    @IBOutlet weak var mapView: MKMapView!
    let routes = MyRoutes.sharedInstance
    
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
        //Update location if we have permission
        locationManager?.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager?.startUpdatingLocation()
        }
        //Zoom to user location
        self.zoomToLocation()
        
        DispatchQueue.main.async {
            self.locationManager?.startUpdatingLocation()
        }
    }
    
    // helper function to zoom to users current location
    private func zoomToLocation() {
        let userLocation = CLLocationCoordinate2D(latitude: (locationManager?.location?.coordinate.latitude)!, longitude: (locationManager?.location?.coordinate.longitude)!)
        let viewRegion = MKCoordinateRegionMakeWithDistance(userLocation, 3000, 3000)
        mapView.setRegion(viewRegion, animated: true)
    }

    // helper functions for animating the stop/start tracking button
    private func changeToStopButton(button: UIButton){
        button.setTitle("Stop Route Tracking", for: .normal)
        button.backgroundColor = UIColor.red
    }
    private func changeToStartButton(button: UIButton){
        button.setTitle("Start Route Tracking", for: .normal)
        button.backgroundColor = UIColor.green
    }
    
    // listener for the start/stop button
    @IBAction func startStopButton(_ sender: UIButton) {
        //Start tracking
        if(tracking==false){
            //set button state and color
            tracking = true
            changeToStopButton(button: sender)
            locationManager?.startUpdatingLocation()
            routes.startRoute()
        } else { //(tracking==true)
            let saveConfirmation = UIAlertController(title: "Save Route", message: "Do you want to save this route?", preferredStyle: .alert)
            let saveAction = UIAlertAction(title: "Save", style: .destructive) { (alert: UIAlertAction!) -> Void in
                self.tracking = false;
                self.changeToStartButton(button: sender)
                self.locationManager?.stopUpdatingLocation()
                self.routes.stopRoute()
                self.mapView.removeOverlays(self.mapView.overlays)
                self.zoomToLocation()
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (alert: UIAlertAction!) -> Void in
                // do nothing and continue tracking route
            }
            saveConfirmation.addAction(saveAction)
            saveConfirmation.addAction(cancelAction)
            present(saveConfirmation, animated: true, completion:nil)
        }
        updateDisplay()
    }
    
    // function is called anytime the location changes
    // used to track users location and to update route information
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // If we are currently tracking a route
        if let route = routes.currentRoute {
            for location in locations {
                let locations = route.locations as Array<CLLocation>
                if let oldLocation = locations.last as CLLocation? {
                    let delta: Double = location.distance(from: oldLocation)
                    route.addDistance(distance: delta)
                }
                route.addNewLocation(location: location)
            }
            updateDisplay()
        } else { // not tracking, just follow user
            zoomToLocation()
        }
    }
    
    // helper function to update the display with the overlay
    private func updateDisplay() {
        if let route = routes.currentRoute {
            if let region = self.mapRegion(myRoute: route) {
                mapView.setRegion(region, animated: true)
            }
            mapView.add(polyLine())
        }
    }
    
    // function to plot the overlay
    private func polyLine() -> MKPolyline {
        if let route = routes.currentRoute {
            var coordinates = route.locations.map({ (location: CLLocation) ->
                CLLocationCoordinate2D in
                return location.coordinate
            })
            return MKPolyline(coordinates: &coordinates, count: route.locations.count)
        }
        return MKPolyline()
    }

    // function to determine map region around the route we are creating
    private func mapRegion(myRoute: MyRoute) -> MKCoordinateRegion? {
        if myRoute.locations.first != nil {
            var regionRect = polyLine().boundingMapRect
            let wPadding = regionRect.size.width * 0.25
            let hPadding = regionRect.size.height * 0.25
            
            //Add padding to the region
            regionRect.size.width += wPadding
            regionRect.size.height += hPadding
            
            //Center the region on the line
            regionRect.origin.x -= wPadding / 2
            regionRect.origin.y -= hPadding / 2
            
            return MKCoordinateRegionForMapRect(regionRect)
        }
        return nil
    }
    
    // function to actually draw the overlay onto the map
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let polyLine = overlay as? MKPolyline {
            let renderer = MKPolylineRenderer(polyline: polyLine)
            renderer.strokeColor = UIColor(hue:0.88, saturation:0.44, brightness:0.77, alpha:0.75)
            renderer.lineWidth = 6
            return renderer
        }
        return overlay as! MKOverlayRenderer
    }
}
