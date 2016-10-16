//
//  MapViewController.swift
//  Drinkr
//
//  Created by Dustin Allen on 10/5/16.
//  Copyright © 2016 Harloch. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import Firebase
import SWRevealViewController

class MapViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet var menu: UIBarButtonItem!
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var drinkrLogo: UILabel!
    
    var locationManager: CLLocationManager = CLLocationManager()
    
    var ref:FIRDatabaseReference!
    var user: FIRUser!
    var userArry: [UserData] = []
    var filtered:[UserData] = []
    
    var venueName:String = ""
    
    let geocoder: CLGeocoder = CLGeocoder()
    //var coordinate = CLLocationCoordinate2D()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = FIRDatabase.database().reference()
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        mapView.showsUserLocation = true
        
        
        let userID = FIRAuth.auth()?.currentUser?.uid
        ref.child("venues").observeEventType(FIRDataEventType.Value, withBlock: { snapshot in
            for childSnap in snapshot.children.allObjects {
                let snap = childSnap as! FIRDataSnapshot
                if userID != snap.key {
                    let approvalStatus = snap.value!["approvalStatus"] as! String!
                    if approvalStatus == "Approved" {
                        self.venueName = snap.value!["venueName"] as! String!
                        let lat = snap.value!["lat"] as! Double!
                        let long = snap.value!["long"] as! Double!
                        let openUntil = snap.value!["venueOpenUntil"] as! String!
                        let drinkForLike = snap.value!["drinkForLike"] as! String!
                        let drinkForCheckIn = snap.value!["drinkForCheckIn"] as! String!
                        
                        let coordinatePoints = CLLocationCoordinate2DMake(lat, long)
                        let dropPin = MKPointAnnotation()
                        dropPin.coordinate = coordinatePoints
                        dropPin.title = self.venueName
                        dropPin.subtitle = openUntil
                        dropPin.subtitle = drinkForLike
                        dropPin.subtitle = drinkForCheckIn
                        
                        self.mapView.addAnnotations([dropPin])
                    }
                }
            }
        })
        
        if revealViewController() != nil {
            //            revealViewController().rearViewRevealWidth = 62
            menu.target = revealViewController()
            menu.action = #selector(SWRevealViewController.revealToggle(_:))
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManagerFunc(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let lastLocation: CLLocation = locations[locations.count - 1]
        
        print(String(format: "%.6f", lastLocation.coordinate.latitude))
        print(String(format: "%.6f", lastLocation.coordinate.longitude))
        
        animateMap(lastLocation)

    }
    
    func animateMap(location: CLLocation) {
        let region = MKCoordinateRegionMakeWithDistance(location.coordinate, 10, 10)
        mapView.setRegion(region, animated: true)
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation: CLLocation = locations[0]
        let latitude = userLocation.coordinate.latitude
        let longitude = userLocation.coordinate.longitude
        let latDelta: CLLocationDegrees = 0.05
        let lonDelta: CLLocationDegrees = 0.05
        let span:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, lonDelta)
        let location: CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
        let region: MKCoordinateRegion = MKCoordinateRegionMake(location, span)
        self.mapView.setRegion(region, animated: true)
        self.mapView.showsUserLocation = true
        locationManager.stopUpdatingLocation()
    }

    @IBAction func menuButton(sender: AnyObject) {
        //performSegueWithIdentifier("sw_rear", sender: sender)
        //self.performSegueWithIdentifier("sw_rear", sender: self)
    }
    
    @IBAction func searchButton(sender: AnyObject) {
        
    }    
}
