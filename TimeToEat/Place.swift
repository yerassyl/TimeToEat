//
//  Place.swift
//  TimeToEat
//
//  Created by User on 07.07.16.
//  Copyright © 2016 yerassyl. All rights reserved.
//

import Foundation
import MapboxDirections
import CoreLocation

var placesTableView: UITableView!

class Place: NSObject {
    
    var placeImage: String?
    var name: String?
    var adress: String?
    var phone = ""
    var workingHours: String?
    var lunchPrice = 0
    var cousine: String?
    var features: String?
    var choices: String?
    var extraInformation: String?
    var lat = 0.0
    var lon = 0.0
    
    func getFirstPhone() -> String {
        let phones = self.phone.characters.split(",").map{String($0)}
        return phones[0]
    }
    
}


// Logic for Places
var backendless = Backendless.sharedInstance()
let directions = Directions.sharedDirections

class PlacesLogic: NSObject {
    
    var places = [Place]()
    // get current location
    
    // Load Places for the launch screen
    func loadInitialPlaces() {
        let dataStore = backendless.data.of(Place.ofClass())
        let whereClause = "lunchPrice > 0" // just for now
        let dataQuery = BackendlessDataQuery()
        dataQuery.whereClause = whereClause
        
        dataStore.find(dataQuery, response: { (result: BackendlessCollection!) in
            let placesResult = result.getCurrentPage()
            for obj in placesResult {
                if let place = obj as? Place {
                    self.places.append(place)
                }
            }
            placesTableView.reloadData()
        }) { (error: Fault!) in
            print("loadInitialPlaces error: \(error)" )
        }
        
    }
    
    
    // calculate distance betwee two points
    static func getDistanceToPlace(currentLocation: CLLocation, placeLat: CLLocationDegrees, placeLon: CLLocationDegrees, completion: (distance: String) -> Void) {
        var distance = "NA"
        //print("location \(getCurrentLocation() )")
        let waypoints = [
            Waypoint(
                coordinate: CLLocationCoordinate2D(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude),
                name: "My Location"),
            Waypoint(
                coordinate: CLLocationCoordinate2D(latitude: placeLat, longitude: placeLon),
                name: "Place To Find"),
            ]
        let options = RouteOptions( waypoints: waypoints, profileIdentifier: MBDirectionsProfileIdentifierCycling)
        
        directions.calculateDirections(options: options) { (waypoints, routes, error) in
            guard error == nil else {
                print("Error calculating directions: \(error!)")
                return
            }
            
            if let route = routes?.first {
                if route.distance > 1000 {
                    distance = "\( round(route.distance/100)/10)km"
                }else {
                    distance = "\(Int(route.distance))m"
                }
                completion(distance: distance)
            }
        }
    
    }
    
    
}