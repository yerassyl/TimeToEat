//
//  MapViewController.swift
//  TimeToEat
//
//  Created by User on 12.07.16.
//  Copyright © 2016 yerassyl. All rights reserved.
//

import UIKit
import Mapbox


class MapViewController: UIViewController, LocationProtocol {
    // get singleton model class to work with logic
    let placesModelLogic = PlacesLogic.PlacesLogicSingleton
    
    var map: MGLMapView!
    var currentLocation: CLLocation?
    
    // this variable determines whether user selected a place or not
    // if not show current location as center
    // if yes, show place location at the top of map and a place details view on top of map to half of the screen height
    var mapSelectedPlace: Place?
    var detailsView: PlaceDetailsView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        // create details view that is hided in the bottom of the screen initially
        detailsView = PlaceDetailsView(frame: CGRect(x: 0, y: screenHeight+10, width: screenWidth, height: screenHeight ) )
        setPanGestureRecognizer(detailsView)
        setMapTapRecognizer()
        
        // if user selected a place, center to place pin and show details view
        if mapSelectedPlace != nil {
            self.selectPlace(mapSelectedPlace!)
        }
        setPins()
    }
    
    // MARK: Map
    
    // set pins of loaded places
    func setPins() {
        for place in placesModelLogic.places {
            // TODO: make custom pin for selected place
            let placeAnnotation = MGLPointAnnotation()
            placeAnnotation.coordinate = CLLocationCoordinate2D(latitude: place.lat, longitude: place.lon)
            placeAnnotation.title = place.name
            placeAnnotation.subtitle = "\(place.lunchPrice) ₸"
            map.addAnnotation(placeAnnotation)
        }
    }
    
    // select place, show its pin on a map and show details view in HalfScreen mode
    func selectPlace(selectedPlace: Place) {
        map.setCenterCoordinate(CLLocationCoordinate2D(latitude: (mapSelectedPlace!.lat),longitude: (mapSelectedPlace!.lon)), zoomLevel: 15.0, animated: false)
        detailsView.place = mapSelectedPlace
        detailsView.setup()
        self.view.addSubview(detailsView!)
        
        detailsView.currentDetailsViewMode = DetailsViewMode.HalfScreen
        detailsView.setDetailsViewPosition(detailsView.currentDetailsViewMode)
    }
    
    func centerToUserLocation() {
        if currentLocation != nil {
            map.setCenterCoordinate(CLLocationCoordinate2D(latitude: (currentLocation!.coordinate.latitude),longitude: (currentLocation!.coordinate.longitude)), zoomLevel: 15.0, animated: false)
        }
    }
    // MARK: - PlaceDetailsView: detailsView gesture responder (selector) methods
    
    func setDetailsViewPosition() {
        if detailsView.currentDetailsViewMode == DetailsViewMode.HalfScreen {
            detailsView.currentDetailsViewMode = DetailsViewMode.SemiHide
        }
        detailsView.setDetailsViewPosition(detailsView.currentDetailsViewMode)
    }
    
    func panDidHappen(panGesture: UIPanGestureRecognizer) {
        let translation = panGesture.translationInView(self.view)
        panGesture.setTranslation(CGPointZero, inView: self.view)
        
        if panGesture.state == UIGestureRecognizerState.Began {
            print("began")
            print(translation)
        }
        
        if panGesture.state == UIGestureRecognizerState.Ended {
            print("ended")
            let finalPosition = detailsView.frame.origin.y
            // find closest mode to finalPosition
            let closestMode = detailsView.findClosestMode(finalPosition)
            detailsView.setDetailsViewPosition(closestMode)
            
        }
        
        if panGesture.state == UIGestureRecognizerState.Changed {
            //print("changed")
            detailsView.moveDetailsView(detailsView.frame.origin.y+translation.y)
        }
        
    }
    
    
    // MARK: - GestureRecognizers
    
    // when map is clicked hide details view animated
    func setMapTapRecognizer() {
        map.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(setDetailsViewPosition) ))
    }
    
    // when details view is dragged, be carefull not to call this when detailsView == nil
    func setPanGestureRecognizer(view: UIView ) {
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.panDidHappen))
        view.addGestureRecognizer(panGestureRecognizer)
    }
    
    // MARK: - LocationProtocol
    func locationDidUpdateToLocation(location: CLLocation) {
        self.currentLocation = location
    }
    
    // MARK: - UI
    func setup() {
        map = MGLMapView(frame: view.bounds, styleURL: MGLStyle.streetsStyleURLWithVersion(9))
        map.zoomEnabled = true
        map.scrollEnabled = true
        map.rotateEnabled = true
        map.userTrackingMode = .Follow
        map.showsUserLocation = true
        self.view.addSubview(map)
    }
    
    
}

