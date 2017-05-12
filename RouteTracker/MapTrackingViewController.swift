//
//  MapTrackingViewController.swift
//  RouteTracker
//
//  Controller for the map view presented when user has started
//  recording their route.
//
//  Created by Tyler Jones, Pete Curtis, Marshall Cargle, Matt Nowzari on 4/15/17.
//  Copyright © 2017 Front Row Crew. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import CoreData

class MapTrackingViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, UIToolbarDelegate {

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
    
    private func zoomToLocation() {
        let userLocation = CLLocationCoordinate2D(latitude: (locationManager?.location?.coordinate.latitude)!, longitude: (locationManager?.location?.coordinate.longitude)!)
        let viewRegion = MKCoordinateRegionMakeWithDistance(userLocation, 3000, 3000)
        mapView.setRegion(viewRegion, animated: true)
    }

    private func changeToStopButton(button: UIButton){
        button.setTitle("Stop Route Tracking", for: .normal)
        button.backgroundColor = UIColor.red
    }
    private func changeToStartButton(button: UIButton){
        button.setTitle("Start Route Tracking", for: .normal)
        button.backgroundColor = UIColor.green
    }
    
    @IBAction func startStopButton(_ sender: UIButton) {
        //Start tracking
        if(tracking==false){
            //set button state and color
            tracking = true
            changeToStopButton(button: sender)
            locationManager?.startUpdatingLocation()
            routes.startRoute()
        } else { //(tracking==true)
            tracking = false;
            changeToStartButton(button: sender)
            locationManager?.stopUpdatingLocation()
            routes.stopRoute()
        }
        updateDisplay()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //Zoom to user location
        zoomToLocation()
        
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
        }
    }
    
    private func updateDisplay() {
        if let route = routes.currentRoute {
            if let region = self.mapRegion(myRoute: route) {
                mapView.setRegion(region, animated: true)
            }
        }
        //mapView.removeOverlays(mapView.overlays)
        mapView.add(polyLine())
    }
    
    
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

    
    private func mapRegion(myRoute: MyRoute) -> MKCoordinateRegion? {
        if let startLocation = myRoute.locations.first {
            var minLatitude = startLocation.coordinate.latitude
            var maxLatitude = startLocation.coordinate.latitude
            
            var minLongitude = startLocation.coordinate.longitude
            var maxLongitude = startLocation.coordinate.longitude
            
            for location in myRoute.locations {
                if location.coordinate.latitude < minLatitude {
                    minLatitude = location.coordinate.latitude
                }
                if location.coordinate.latitude > maxLatitude {
                    maxLatitude = location.coordinate.latitude
                }
                
                if location.coordinate.longitude < minLongitude {
                    minLongitude = location.coordinate.longitude
                }
                if location.coordinate.latitude > maxLongitude {
                    maxLongitude = location.coordinate.longitude
                }
            }
            
            let center = CLLocationCoordinate2D(latitude: (minLatitude + maxLatitude)/2.0,
                                                longitude: (minLongitude + maxLongitude)/2.0)
            let viewRegion = MKCoordinateSpan(latitudeDelta: (maxLatitude - minLatitude)*1.5,
                                        longitudeDelta: (maxLongitude - minLongitude)*1.5)
            return MKCoordinateRegion(center: center, span: viewRegion)

        }
        return nil
    }
    
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
