//
//  MainViewController.swift
//  TimeToEat
//
//  Created by User on 07.07.16.
//  Copyright © 2016 yerassyl. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher




class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate {

    
    var placesModelLogic = PlacesLogic()
    
    var locationManager: CLLocationManager!
    var currentLocation = CLLocation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        
        placesTableView = UITableView()
        placesTableView.delegate = self
        placesTableView.dataSource = self
        setup()
        placesModelLogic.loadInitialPlaces()
        
        // get users current location
        if (CLLocationManager.locationServicesEnabled()) {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestLocation()
        }
        
    }
    
    // MARK: - CLLocationManagerDelegate
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            print(location)
            self.currentLocation = location
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print(error)
    }
    
    // MARK: - Table View
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return placesModelLogic.places.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = PlaceTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "place")
        let currentPlace = placesModelLogic.places[indexPath.row]
        
        if currentPlace.placeImage != nil {
            cell.placeImageView?.kf_setImageWithURL(NSURL(string: currentPlace.placeImage!)!, placeholderImage: UIImage(named:"placeholder") )
        }
        
        cell.nameLabel.text = currentPlace.name
        // lucnhPrice is nil, but it is set in Backendless
        cell.businessLunchPriceLabel.text = "\(currentPlace.lunchPrice)"
        
        // calculate distance
        PlacesLogic.getDistanceToPlace(currentLocation, placeLat: currentPlace.lat, placeLon: currentPlace.lon ) {
            distance in
            cell.distanceToLabel.text = distance
            // to do: what if couldn't calculate distance to
        }

        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        // calculate cell width
        //let cellWidth = tableView.frame.height/5
        return 136
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectedPlace = placesModelLogic.places[indexPath.row]
        let placeVC = PlaceViewController()
        
        placeVC.place = selectedPlace
        self.navigationController?.pushViewController(placeVC, animated: true)
        
    }
    
    // MARK: - UI
    
    func openMapView() {
        let mapVC = MapViewController()
        self.navigationController?.pushViewController(mapVC, animated: true)
    }
    
    func setup() {
        // setup UINavBar items
        let mapItem = UIBarButtonItem(image: UIImage(named: "map-icon"), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(self.openMapView) )
        let searchItem = UIBarButtonItem(image: UIImage(named: "search-icon"), style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        mapItem.tintColor = UIColor.whiteColor()
        searchItem.tintColor = UIColor.whiteColor()
        self.navigationItem.rightBarButtonItems = [mapItem, searchItem]
        
        let searchBarButton = UIButton()
        searchBarButton.titleLabel?.font = UIFont.getMainFont(14)
        searchBarButton.titleLabel?.textAlignment = .Left
        searchBarButton.setTitle("Голоден", forState: UIControlState.Normal)
        //searchBarButton.titleLabel?.sizeToFit()
        
        self.navigationItem.titleView = searchBarButton
        
        // table view
        placesTableView.separatorColor = UIColor.primaryRedColor()
        //placesTableView.layoutMargins = UIEdgeInsetsZero
        self.view.addSubview(placesTableView)
        placesTableView.snp_makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        
    }
    

}
