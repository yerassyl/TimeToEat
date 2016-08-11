//
//  UserCity.swift
//  TimeToEat
//
//  Created by User on 09.08.16.
//  Copyright © 2016 yerassyl. All rights reserved.
//  
//  Class for detecting user's city, whether location services are enabled etc

import Foundation

class City:NSObject {
    var name: String?
    
}

class UserCity:CLGeocoder {
    
    static var city = City()
    
    static func getUserLocationCity(currentLocation: CLLocation, completion:(Void )-> Void ){
        let geocoder = CLGeocoder()
//        let AlmatyLocation = CLLocation(latitude: 43.292330, longitude: 76.946797)
//        let AstanaLocation = CLLocation(latitude: 51.154063, longitude: 71.466758)
        
        // set user defaults to english to force city name return in English
        let userDefaultLanguages = [ NSUserDefaults.standardUserDefaults().objectForKey("AppleLanguages") ]
        NSUserDefaults.standardUserDefaults().setObject(["en"], forKey: "AppleLanguages")
        geocoder.reverseGeocodeLocation(currentLocation) { (placemarks:[CLPlacemark]?, error: NSError?) in
            var placeMark: CLPlacemark!
            if error == nil && placemarks?.count > 0 {
                placeMark = placemarks![0] as CLPlacemark
                self.city.name = placeMark.locality
                //print("user city is: \(placeMark.locality) ")
            } else {
                //print("getUserLocation error: \(error)")
                
            }
            // reset user defaults
            NSUserDefaults.standardUserDefaults().setObject(userDefaultLanguages[0], forKey: "AppleLanguages")
            completion()
        }
    }
    
    
}