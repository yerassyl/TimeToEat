//
//  InteractionGestureExtension.swift
//  TimeToEat
//
//  Created by User on 05.08.16.
//  Copyright © 2016 yerassyl. All rights reserved.
//

import UIKit
import Mapbox

extension MapViewController: InteractionGestureRecognizerDelegate, MapPinsProtocol {
    func interactionDidHappen() {
        self.setMapActive()
    }
    
    func reloadPins() {
        self.removeAllPins()
        self.setPins()
    }
    
    // set pins of loaded places
    func setPins() {
        for place in placesModelLogic.places {
            let placeAnnotation = MGLPointAnnotation()
            placeAnnotation.coordinate = CLLocationCoordinate2D(latitude: place.lat, longitude: place.lon)
            //  make custom pin for selected place
            placeAnnotation.title = place.name
            map.addAnnotation(placeAnnotation)
        }
    }
    
    func removeAllPins() {
        guard let annotations = self.map.annotations else { return print("Annotations Error") }
        if annotations.count != 0 {
            for annotation in annotations {
                self.map.removeAnnotation(annotation)
            }
        } else {
            return
        }
    }
    
}