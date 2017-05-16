//
//  RouteMapViewController.swift
//  RouteTracker
//
//  Controller for the map view presented when user views a previously saved route
//  This view is accessed by clicking on any of the routes in the saved routes list
//
//  Created by Tyler Jones, Pete Curtis, Marshall Cargle, Matt Nowzari on 4/15/17.
//  Copyright © 2017 Front Row Crew. All rights reserved.
//

import UIKit 
import MapKit
import CoreLocation

class RouteMapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    private let routes = MyRoutes.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        self.updateDisplay()
        self.mapView.addOverlays(mapView.overlays)
        
    }
    
    // function to add the overlay from the saved route
    private func updateDisplay() {
        if let selectedRoute = routes.selectedtRoute {
            if let region = self.mapRegion(myRoute: selectedRoute) {
                mapView.setRegion(region, animated: true)
            }
            mapView.add(polyLine())
        }
        mapView.addOverlays(mapView.overlays)
    }
    
    // function to create the overlay based on the saved route
    private func polyLine() -> MKPolyline {
        if let selectedRoute = routes.selectedtRoute {
            var coordinates = selectedRoute.locations.map({ (location: CLLocation) ->
                CLLocationCoordinate2D in
                return location.coordinate
            })
            return MKPolyline(coordinates: &coordinates, count: selectedRoute.locations.count)
        }
        return MKPolyline()
    }
    
    // function to define a region around the saved route
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
    
    // function to draw the overlay onto the mapview
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
