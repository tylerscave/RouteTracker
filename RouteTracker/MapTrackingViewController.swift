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

class MapTrackingViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    var tracking = false;
    var locationManager:CLLocationManager?
    @IBOutlet weak var mapView: MKMapView!
    //    let timeLocation = Route(context: context)
    var routes = MyRoutes()

    
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
        // Do any additional setup after loading the view.
        
    }
 
//IMPLEMENTED IN THE MYROUTES MODESL
//    func insertTimeLocPairStart(){
//        //START TIME
//        timeLocation.startTimestamp = NSDate()
//        
//        //SAVE LOCATION
//        
//        //TODO
//        appDelegate.saveContext()
//     
//    }
//    func insertTimeLocPairEnd(){
//        //START TIME
//        timeLocation.endTimestamp = NSDate()
//        
//        //SAVE LOCATION
//        
//        //TODO
//        appDelegate.saveContext()
//        
//    }
    func changeToStopButton(button: UIButton){
        button.setTitle("Stop Route Tracking", for: .normal)
        button.setTitleColor(UIColor.red, for: .normal)
    }
    func changeToStartButton(button: UIButton){
        button.setTitle("Start Route Tracking", for: .normal)
        button.setTitleColor(UIColor.green, for: .normal)
    }
    
    @IBAction func startStopButton(_ sender: UIButton) {
        //        let newRoute = NSEntityDescription.insertNewObject(forEntityName: "RouteTacker", into: context)

        //Start tracking
        if(tracking==false){
            //set button state and color
            tracking = true
            changeToStopButton(button: sender)
            routes.startRoute()
//            insertTimeLocPairStart()
        
            //OLD
            //            let timeLocation = Route(contsext: context)
            //save route to Core Data(variable located in App Delegate)
//            newRoute.setValue(NSDate(), forKey: "startTimeStamp")
//            newRoute.setValue(NSDate(), forKey: "locations")
            //CURRENT LOCATION

        }

        else{ //(tracking==true)
            tracking = false;
            changeToStartButton(button: sender)
            routes.stopRoute()

            //END TIME
//            insertTimeLocPairEnd()

            //TODO
            //LAST LOCATION
            //DISTANCE CALCULATED
        }
    }
    
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
