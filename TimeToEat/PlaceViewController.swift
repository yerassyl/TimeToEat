//
//  PlaceViewController.swift
//  TimeToEat
//
//  Created by User on 12.07.16.
//  Copyright © 2016 yerassyl. All rights reserved.
//

import UIKit
import Mapbox
import AlamofireObjectMapper

class PlaceViewController: UIViewController, LocationProtocol {
    
    var place: Place!
    var distanceLabel: UILabel!
    var distance = "NA"
    
    var map: MGLMapView!
    var currentLocation = CLLocation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        setup()
        
        let LocationMgr = Location.SharedManager
        LocationMgr.delegate = self
        LocationMgr.startUpdatingLocation()
        print("show place")
    }
    
    // MARK: - Actions
    func call() {
        let phone = self.place.getFirstPhone()
        if let url = NSURL(string: "tel://\(phone)") {
            UIApplication.sharedApplication().openURL(url)
        }
    }
    
    // MARK: - Location Protocol
    func locationDidUpdateToLocation(location: CLLocation) {
        self.currentLocation = location
    }
    
    // MARK: - UI Updates
    
    func updateDistanceLabel(distance: String) {
        self.distanceLabel.text = distance
    }
    
    func setup() {
        self.navigationItem.title = "ВРЕМЯ ЕСТЬ"
        self.navigationItem.titleView?.tintColor = UIColor.whiteColor()

        let navbarHeight = self.navigationController?.navigationBar.frame.height
        let mapHeight = screenHeight/2
        
        // SETUP MAP
        map = MGLMapView(frame: CGRectMake(0.0, navbarHeight!, screenWidth, mapHeight), styleURL: MGLStyle.streetsStyleURLWithVersion(9))
        map.zoomEnabled = false
        map.scrollEnabled = true
        map.rotateEnabled = true
        map.userTrackingMode = .None // do not follow
        map.showsUserLocation = true
        
        map.setCenterCoordinate(CLLocationCoordinate2D(latitude: self.place.lat,longitude: self.place.lon ), zoomLevel: 15.0, animated: false)
        self.view.addSubview(map)
        //map.delegate = self
        
        let hello = MGLPointAnnotation()
        hello.coordinate = CLLocationCoordinate2D(latitude: self.place.lat, longitude: self.place.lon)
        hello.title = "Hello world!"
        hello.subtitle = "Welcome to my marker"
        map.addAnnotation(hello)
        
    }
}