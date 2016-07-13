//
//  MapViewController.swift
//  TimeToEat
//
//  Created by User on 12.07.16.
//  Copyright © 2016 yerassyl. All rights reserved.
//

import UIKit
import Mapbox

class MapViewController: UIViewController, CLLocationManagerDelegate {

    var map: MGLMapView!
    var locationManager: CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        if (CLLocationManager.locationServicesEnabled()) {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
        }
        
    }

    func setup() {
        map = MGLMapView(frame: view.bounds, styleURL: MGLStyle.streetsStyleURLWithVersion(9))
        map.zoomEnabled = true
        map.scrollEnabled = true
        map.rotateEnabled = true
        map.userTrackingMode = .Follow
        map.showsUserLocation = true
        let userLocation = map.userLocation
        print("userLocation: \(userLocation)")
        
//        map.setCenterCoordinate(CLLocationCoordinate2D(latitude: (userLocation?.location?.coordinate.latitude)!,longitude: (userLocation?.location?.coordinate.longitude)!), zoomLevel: 15.0, animated: false)
       map.setCenterCoordinate(CLLocationCoordinate2D(latitude: 43.255671,longitude:76.942694 ), zoomLevel: 15.0, animated: false)
        self.view.addSubview(map)
        
    }
    
}
