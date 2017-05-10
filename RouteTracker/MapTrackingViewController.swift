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

class MapTrackingViewController: UIViewController, CLLocationManagerDelegate {

    var tracking = false;
    var locationManager:CLLocationManager?
//    let timeLocation = Route(context: context)
    var routes = MyRoutes()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager = CLLocationManager()
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.delegate = self
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
