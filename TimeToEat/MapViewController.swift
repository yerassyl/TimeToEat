//
//  MapViewController.swift
//  TimeToEat
//
//  Created by User on 12.07.16.
//  Copyright © 2016 yerassyl. All rights reserved.
//

import UIKit
import Mapbox


class MapViewController: UIViewController, LocationProtocol, MGLMapViewDelegate {
    // get singleton model class to work with logic
    let placesModelLogic = PlacesLogic.PlacesLogicSingleton
    
    var map: MGLMapView!
    
    var currentLocation: CLLocation?
    
    // this variables determines whether user selected a place or not
    // if not show current location as center
    // if yes, show place location at the top of map and a place details view on top of map to half of the screen height
    var mapSelectedPlace: Place?
    var mapSelectedAnnotation: MGLAnnotation?
    
    var detailsView: PlaceDetailsView!
    var mapTapGestureRecognizer: UITapGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()

        let LocationMgr = Location.SharedManager
        LocationMgr.delegate = self
        LocationMgr.startUpdatingLocation()
        
        // create details view that is hided in the bottom of the screen initially
        detailsView = PlaceDetailsView(frame: CGRect(x: 0, y: screenHeight+10, width: screenWidth, height: screenHeight ) )
        self.view.addSubview(detailsView)
        
        mapTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(setMapActive) )
        setPanGestureRecognizer(detailsView)
        
        
        // if user selected a place, center to place pin and show details view
        if mapSelectedPlace != nil {
            setMapTapGestureRecognizer()
            detailsView.currentDetailsViewMode = DetailsViewMode.HalfScreen
            self.selectPlace(mapSelectedPlace!)
        }
        setPins()
    }
    
    // MARK: Map
    
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
    
    // select place, show its pin on a map and show details view in HalfScreen mode
    func selectPlace(selectedPlace: Place) {
        self.mapSelectedPlace = selectedPlace
        // center place pin to top half screen
        UIView.animateWithDuration(0.4) { 
            self.map.setCenterCoordinate(CLLocationCoordinate2D(latitude: (selectedPlace.lat),longitude: (selectedPlace.lon)), zoomLevel: 15.0, animated: false)
        }
        detailsView.place = selectedPlace
        detailsView.setup()
        
        if detailsView.currentDetailsViewMode == DetailsViewMode.Hide {
            detailsView.currentDetailsViewMode = DetailsViewMode.SemiHide
        }
        detailsView.setDetailsViewPosition(detailsView.currentDetailsViewMode)
    }
    
    func centerToUserLocation() {
        if currentLocation != nil {
            print("center to loc")
            map.setCenterCoordinate(CLLocationCoordinate2D(latitude: (currentLocation!.coordinate.latitude),longitude: (currentLocation!.coordinate.longitude)), zoomLevel: self.map.zoomLevel, animated: false)
        }
    }

    func zoomIn(){
        self.map.setZoomLevel(self.map.zoomLevel+1.0, animated: true)
    }
    
    func zoomOut(){
        self.map.setZoomLevel(self.map.zoomLevel-1.0, animated: true)
    }
    
    // MARK: - PlaceDetailsView: detailsView gesture responder (selector) methods
    
    func setMapActive() {
        if detailsView.currentDetailsViewMode == DetailsViewMode.HalfScreen {
            detailsView.currentDetailsViewMode = DetailsViewMode.SemiHide
            self.removeMapTapGestureRecognizer()
        }
        detailsView.setDetailsViewPosition(detailsView.currentDetailsViewMode)
    }
    
    func panDidHappen(panGesture: UIPanGestureRecognizer) {
        let translation = panGesture.translationInView(self.view)
        panGesture.setTranslation(CGPointZero, inView: self.view)
        
        if panGesture.state == UIGestureRecognizerState.Began {
            print(translation)
        }
        
        if panGesture.state == UIGestureRecognizerState.Ended {
            let finalPosition = detailsView.frame.origin.y
            // find closest mode to finalPosition
            let closestMode = detailsView.findClosestMode(finalPosition)
            if closestMode == DetailsViewMode.HalfScreen {
                self.setMapTapGestureRecognizer()
            }else if closestMode == DetailsViewMode.SemiHide {
                self.removeMapTapGestureRecognizer()
            }else if closestMode == DetailsViewMode.Hide {
                self.removeMapTapGestureRecognizer()
            }
            detailsView.setDetailsViewPosition(closestMode)
            
        }
        
        if panGesture.state == UIGestureRecognizerState.Changed {
            //print("changed")
            detailsView.moveDetailsView(detailsView.frame.origin.y+translation.y)
        }
        
    }
    
    
    // MARK: - GestureRecognizers
    
    // when map is clicked hide details view animated
    func setMapTapGestureRecognizer() {
        map.addGestureRecognizer(mapTapGestureRecognizer)
    }
    
    func removeMapTapGestureRecognizer() {
        map.removeGestureRecognizer(mapTapGestureRecognizer)
    }
    
    // when details view is dragged, be carefull not to call this when detailsView == nil
    func setPanGestureRecognizer(view: UIView ) {
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.panDidHappen))
        view.addGestureRecognizer(panGestureRecognizer)
    }
    
    
    // MARK: - MGLMapViewDelegate
    func mapView(mapView: MGLMapView, didSelectAnnotation annotation: MGLAnnotation) {
        print("annotation selected")
        // deselect previous annotation
        if self.mapSelectedAnnotation != nil {
            let reuseIdentifier = reuseIdentifierForAnnotation(self.mapSelectedAnnotation!)
            if let annotationImage = mapView.dequeueReusableAnnotationImageWithIdentifier(reuseIdentifier) {
                if annotationImage.image == UIImage(named: "selected-pin")! {
                    annotationImage.image = UIImage(named: "pin")!
                } else {
                    annotationImage.image = UIImage(named: "pin")!
                }
            }

        }
        
        // select tapped annotation
        
        let reuseIdentifier = reuseIdentifierForAnnotation(annotation)
        if let annotationImage = mapView.dequeueReusableAnnotationImageWithIdentifier(reuseIdentifier) {
            if annotationImage.image == UIImage(named: "pin")! {
                annotationImage.image = UIImage(named: "selected-pin")!
            } else {
                annotationImage.image = UIImage(named: "selected-pin")!
            }
            self.mapSelectedAnnotation = annotation
        }
        

        for place in self.placesModelLogic.places {
            if place.name == annotation.title! {
                self.selectPlace(place)
                break
            }
        }
    }
    
    
    func mapView(mapView: MGLMapView, imageForAnnotation annotation: MGLAnnotation) -> MGLAnnotationImage? {
        // get the custom reuse identifier for this annotation
        let reuseIdentifier = reuseIdentifierForAnnotation(annotation)
        // try to reuse an existing annotation image, if it exists
        var annotationImage = mapView.dequeueReusableAnnotationImageWithIdentifier(reuseIdentifier)
        
        // if the annotation image hasn‘t been used yet, initialize it here with the reuse identifier
        if annotationImage == nil {
            // lookup the image for this annotation
            var image = imageForAnnotation(annotation)
            image = image.imageWithAlignmentRectInsets(UIEdgeInsetsMake(0, 0, image.size.height/2, 0))
            annotationImage = MGLAnnotationImage(image: image, reuseIdentifier: reuseIdentifier)
        }
        
        return annotationImage
        
    }
    
    // create a reuse identifier string by concatenating the annotation coordinate, title, subtitle
    func reuseIdentifierForAnnotation(annotation: MGLAnnotation) -> String {
        var reuseIdentifier = "\(annotation.coordinate.latitude),\(annotation.coordinate.longitude)"
        if let title = annotation.title where title != nil {
            reuseIdentifier += title!
        }
        if let subtitle = annotation.subtitle where subtitle != nil {
            reuseIdentifier += subtitle!
        }
        return reuseIdentifier
    }
    
    // lookup the image to load by switching on the annotation's title string
    func imageForAnnotation(annotation: MGLAnnotation) -> UIImage {
        var imageName = ""
        if let title = annotation.title where title != nil {
            if self.mapSelectedPlace != nil {
                if title == self.mapSelectedPlace?.name {
                    imageName = "selected-pin"
                    self.mapSelectedAnnotation = annotation
                } else {
                    imageName = "pin"
                }
            }else {
                imageName = "pin"
            }
            
        }
        return UIImage(named: imageName)!
    }
    
    
    // MARK: - LocationProtocol
    func locationDidUpdateToLocation(location: CLLocation) {
        self.currentLocation = location
        print("got location")
    }
    
    // MARK: - UI
    
    func openSearchView(){
        let searchVC = SearchViewController()
        self.navigationController?.pushViewController(searchVC, animated: false)
    }

    // navigate to main view, actually perform back navigation
    func openMainView(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func setup() {
        // setup navbar
        self.navigationItem.titleView = UIImageView(image: UIImage(named: "logo_block"))
        let listItem = UIBarButtonItem(image: UIImage(named: "list"), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(self.openMainView) )
        let searchItem = UIBarButtonItem(image: UIImage(named: "search-icon"), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(self.openSearchView))
        listItem.tintColor = UIColor.whiteColor()
        searchItem.tintColor = UIColor.whiteColor()
        if self.mapSelectedPlace == nil {
            self.navigationItem.rightBarButtonItems = [listItem, searchItem]
        }
        
        map = MGLMapView(frame: view.bounds, styleURL: MGLStyle.streetsStyleURLWithVersion(9))
        map.delegate = self
        map.zoomEnabled = true
        map.scrollEnabled = true
        map.rotateEnabled = true
        map.userTrackingMode = .Follow
        map.showsUserLocation = true
        self.view.addSubview(map)
        
        // setup map buttons 
        
        let locationButton = UIButton()
        locationButton.setImage(UIImage(named: "location"), forState: UIControlState.Normal)
        self.view.addSubview(locationButton)
        locationButton.snp_makeConstraints { (make) in
            make.top.equalTo(self.view).offset(navbarHeight+80)
            make.right.equalTo(self.view).offset(-12)
        }
        locationButton.addTarget(self, action: #selector(self.centerToUserLocation), forControlEvents: UIControlEvents.TouchUpInside)
        
        let zoomInButton = UIButton()
        zoomInButton.setImage(UIImage(named: "zoom-in"), forState: UIControlState.Normal)
        self.view.addSubview(zoomInButton)
        zoomInButton.snp_makeConstraints { (make) in
            make.top.equalTo(self.view).offset(screenHeight*0.4)
            make.right.equalTo(self.view).offset(-12)
        }
        zoomInButton.addTarget(self, action: #selector(self.zoomIn), forControlEvents: UIControlEvents.TouchUpInside)
        
        let zoomOutButton = UIButton()
        zoomOutButton.setImage(UIImage(named: "zoom-out"), forState: UIControlState.Normal)
        self.view.addSubview(zoomOutButton)
        zoomOutButton.snp_makeConstraints { (make) in
            make.top.equalTo(zoomInButton.snp_bottom).offset(8)
            make.right.equalTo(self.view).offset(-12)
        }
        zoomOutButton.addTarget(self, action: #selector(self.zoomOut), forControlEvents: UIControlEvents.TouchUpInside)
        
    }
    
    
}


