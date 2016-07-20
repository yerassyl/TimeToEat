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


class Place: NSObject {
    
    var placeImage: String?
    var name: String?
    var adress: String?
    var phone = ""
    var workingHours: String?
    var lunchPrice = 0
    var lunchType: String?
    var cousine: String?
    var features: String?
    var choices: String?
    var extraInformation: String?
    var lat = 0.0
    var lon = 0.0
    
    var distanceToDouble = 0.0
    var distanceToStr: String? // virtual attribute, do not use value retrieved from backendless
    
    func getFirstPhone() -> String {
        let phones = self.phone.characters.split(",").map{String($0)}
        if phones.count == 0 {
            return "NA"
        }
        return phones[0]
    }
    
}


// Logic for Places
var backendless = Backendless.sharedInstance()
let directions = Directions.sharedDirections

class PlacesLogic: NSObject  {
    
    // store list of loaded places
    var places = [Place]()
    // store list of distances to loaded places, index in "distances" corresponds to place at index in "places"
    
    // Load Places for the launch screen
    func loadInitialPlaces(completion: (Void) -> Void ) {
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
            completion()
        }) { (error: Fault!) in
            print("loadInitialPlaces error: \(error)" )
        }
        
    }
    
    // calculate distances to loaded places
    func calculateDistances(currentLocation: CLLocation, completion: (Void)->Void) {
        var i = 0
        for place in self.places {
            self.getDistanceToPlace(currentLocation, place: place) {
                // to do: what if couldn't calculate distance to
                distance, distanceDouble in
                print("\(i) \(place.name) " )
                place.distanceToStr = distance
                place.distanceToDouble = distanceDouble
                if i == self.places.count - 1 {
                    completion()
                    return
                }
                i += 1
            }
        }
    }
    
    // calculate distance betwee two points
    func getDistanceToPlace(currentLocation: CLLocation, place: Place,  completion: (distance: String, distanceDouble: Double) -> Void) {
        var distance = "NA"
        //print("location \(getCurrentLocation() )")
        let waypoints = [
            Waypoint(
                coordinate: CLLocationCoordinate2D(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude),
                name: "My Location"),
            Waypoint(
                coordinate: CLLocationCoordinate2D(latitude: place.lat, longitude: place.lon),
                name: "Place To Find"),
            ]
        let options = RouteOptions( waypoints: waypoints, profileIdentifier: MBDirectionsProfileIdentifierCycling)
        
        directions.calculateDirections(options: options) { (waypoints, routes, error) in
            guard error == nil else {
                //print("Error calculating directions: \(error!)")
                print("Error calculating directions")
                return
            }

            if let route = routes?.first {
                if route.distance > 1000 {
                    distance = "📍\( round(route.distance/100)/10) км до вас"
                }else {
                    distance = "📍\(Int(route.distance)) м до вас"
                }
                completion(distance: distance, distanceDouble: Double(route.distance))
            }
        }
    
    }

    
}