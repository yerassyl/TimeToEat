//
//  SearchBoundary.swift
//  TimeToEat
//
//  Created by User on 05.08.16.
//  Copyright © 2016 yerassyl. All rights reserved.
//

import Foundation

protocol SearchBoundaryProtocol {
    func initializeBoundaryToUserLocation(currentLocation: CLLocation)
}


class SearchBoundary: NSObject {
    static let searchBoundaryInstance = SearchBoundary()
    
    // store corners of boundary where to search for places
    var leftCorner = CLLocationCoordinate2D()
    var rightCorner = CLLocationCoordinate2D()
    // boundary treshold from user location
    let boundaryDistance: CLLocationDistance = 5/1000
    
    // save last boundary for loaded places
    var prevLeftCorner = CLLocationCoordinate2D()
    var prevRightCorner = CLLocationCoordinate2D()
    
    
    
    // MARK: - SearchBoundary Sizing

    func initializeBoundaryToUserLocation(currentLocation: CLLocation) {
        leftCorner.latitude = currentLocation.coordinate.latitude - self.boundaryDistance
        leftCorner.longitude = currentLocation.coordinate.longitude - self.boundaryDistance
        
        rightCorner.latitude = currentLocation.coordinate.latitude + self.boundaryDistance
        rightCorner.longitude = currentLocation.coordinate.longitude + self.boundaryDistance
//        print("leftCorner: \(leftCorner.latitude), \(leftCorner.longitude)")
//        print("rightCorner: \(rightCorner.latitude), \(rightCorner.longitude)")
    }
    
    func increaseSearchBoundary(){
        prevLeftCorner = leftCorner
        prevRightCorner = rightCorner
        
        leftCorner.latitude += self.boundaryDistance
        leftCorner.longitude += self.boundaryDistance
        
        rightCorner.latitude += self.boundaryDistance
        rightCorner.longitude += self.boundaryDistance
    }
    
    
}
