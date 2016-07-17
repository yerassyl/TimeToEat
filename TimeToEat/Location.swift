//
//  Location.swift
//  TimeToEat
//
//  Created by User on 15.07.16.
//  Copyright © 2016 yerassyl. All rights reserved.
//

import Foundation


protocol LocationProtocol {
    func locationDidUpdateToLocation(location: CLLocation)
    
}

//let kLocationDidChangeNotification = "LocationDidChangeNotification"

class Location: NSObject, CLLocationManagerDelegate {
    
    static let SharedManager = Location()
    private var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var delegate : LocationProtocol!
    
    override init(){
        super.init()
        if (CLLocationManager.locationServicesEnabled()) {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.distanceFilter = kCLLocationAccuracyHundredMeters
            locationManager.requestWhenInUseAuthorization()
        }
        
    }
    
    // MARK: - CLLocationManagerDelegate
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            currentLocation = location
            //let userInfo : NSDictionary = ["location" : currentLocation!]
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                self.delegate.locationDidUpdateToLocation(self.currentLocation!)
                //NSNotificationCenter.defaultCenter().postNotificationName(kLocationDidChangeNotification, object: self, userInfo: userInfo as [NSObject : AnyObject])
            }
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
    
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.AuthorizedWhenInUse {
            locationManager.requestLocation()
            print("requestLocation")
        }
    }
    
    
}