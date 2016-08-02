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

protocol PlaceProtocol {
    func updateDistanceLabel()
}

class Place: NSObject {
    
    var objectId: String?
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
    
    // virtual attributes, do not use value retrieved from backendless
    var distanceToDouble = 0.0
    var distanceToStr = "Загрузка..."
    
    func getFirstPhone() -> String {
        let phones = self.phone.characters.split(",").map{String($0)}
        if phones.count == 0 {
            return "NA"
        }
        return phones[0]
    }
    
    func call(completion: (Void)->Void) {
        let phone = self.getFirstPhone()
        if phone != "NA" {
            if let url = NSURL(string: "tel://\(phone)") {
                UIApplication.sharedApplication().openURL(url)
            }
        }
        completion()
    }
    
    
}



// Logic for Places
var backendless = Backendless.sharedInstance()
let directions = Directions.sharedDirections

class PlacesLogic: NSObject  {
    static let PlacesLogicSingleton = PlacesLogic()
    
    // store list of loaded places
    var places = [Place]()
    // MARK: - Backendless 
    
    // Load Places for the launch screen
    func loadInitialPlaces(completion: (Void) -> Void ) {
        let dataStore = backendless.data.of(Place.ofClass())
        let whereClause = "lunchPrice > 0" // just for now
        let dataQuery = BackendlessDataQuery()
        dataQuery.whereClause = whereClause
        dataStore.find(dataQuery, response: { (result: BackendlessCollection!) in
            let placesResult = result.getCurrentPage()
            self.places = []
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
    
    func searchPlaces(name: String = "", priceFrom: Int = 0, priceTo: Int = 9999, distanceFrom: Double = 0.0, distanceTo: Double = 0.0, completion: (Void) -> Void ) {
        let dataStore = backendless.data.of(Place.ofClass())
        let whereClause = "name LIKE '%\(name)%' and lunchPrice >= \(priceFrom) and lunchPrice <= \(priceTo)"
        let dataQuery = BackendlessDataQuery()
        dataQuery.whereClause = whereClause

        dataStore.find(dataQuery, response: { (result: BackendlessCollection!) in
            self.places.removeAll()
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
    
    // MARK: - Places 
    
    // Sort places in ascending order
    func sortBy(sortingType: SortingType){
        switch sortingType {
        case .byDistance:
            self.places.sortInPlace({ (s1: Place, s2: Place) -> Bool in
                return s1.distanceToDouble < s2.distanceToDouble
            })
        case .byPrice:
            self.places.sortInPlace({ (s1: Place, s2: Place) -> Bool in
                return s1.lunchPrice < s2.lunchPrice
            })
        }
        
    }
    
    func filterToDistance(distanceFrom: Double, distanceTo: Double) {
        self.places = self.places.filter { (place: Place) -> Bool in
            return place.distanceToDouble >= distanceFrom && place.distanceToDouble <= distanceTo
        }
    }
    
    // MARK: - Mapbox 
    // calculate distance between two loations offline
    func getDistance(currentLocation: CLLocation, placeLocation: CLLocation ) -> CLLocationDistance {
        return currentLocation.distanceFromLocation(placeLocation)
    }
    
    // MARK: - Mapbox Directions API
    
    // calculate distances to loaded places
    // use ofline method: getDistance
    func calculateDistances(currentLocation: CLLocation, completion: (Void)->Void) {
        //var i = 0
        for place in self.places {
            let placeLocation = CLLocation(latitude: place.lat, longitude: place.lon)
            let distance = self.getDistance(currentLocation, placeLocation: placeLocation )
            var distanceStr = ""
            place.distanceToDouble = distance
            if distance > 1000 {
                distanceStr = "📍\(round(distance/100)/10) км до вас"
            } else {
                distanceStr = "📍\(Int(distance)) м до вас"
            }
            place.distanceToStr = "\(distanceStr)"
        }
        completion()
    }
    
    // calculate distance between two points
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