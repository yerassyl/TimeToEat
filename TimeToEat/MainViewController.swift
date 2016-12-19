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
import SwiftSpinner

var screenWidth: CGFloat!
var screenHeight: CGFloat!
var navbarHeight: CGFloat! // actually navbar height + statusbar height


protocol PlacesTableViewProtocol {
    func reloadPlacesTableView(sortingType: SortingType, searched: Bool )
    func loadInitialPlaces()
}

class MainViewController: UIViewController, //UITableViewDataSource, UITableViewDelegate,
    LocationProtocol, PlacesTableViewProtocol {
    
    // get singleton model class to work with logic
    let placesModelLogic = PlacesLogic.PlacesLogicSingleton
    var sortingType = SortingType.byDistance
    // get location singleton class to work with location logic
    let LocationMgr = Location.SharedManager
    // get search boundary singleton to work with searching area for places
    //let searchBoundary = SearchBoundary.searchBoundaryInstance
    
    var placesTableView: UITableView!
    var placesRefreshControl: UIRefreshControl!
    var noPlacesFoundView: NoPlacesFound!
    var noCityView: NoCityView!
    var notAvailableCityView: NotAvailableCityView!
    var noLocationServicesView: NoLocationServicesView!
    
    var mapItem: UIBarButtonItem!
    var searchItem: UIBarButtonItem!
    
    var currentLocation: CLLocation?
    
    // ViewControllers to be pushed 
    let mapVC = MapViewController()
    let searchVC = SearchViewController()
    
    var loadedInitialPlaces = false
    var cellToTriggerLoadingPlaces = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.LocationMgr.delegate = self
        self.LocationMgr.startUpdatingLocation()
        
        self.view.backgroundColor = UIColor.whiteColor()
        screenWidth = UIScreen.mainScreen().bounds.width
        screenHeight = UIScreen.mainScreen().bounds.height
        navbarHeight = self.navigationController!.navigationBar.frame.height + UIApplication.sharedApplication().statusBarFrame.size.height
        
        placesTableView = UITableView()
        placesTableView.delegate = self
        placesTableView.dataSource = self
        placesTableView.separatorStyle = .None
        placesTableView.registerClass(PlaceTableViewCell.self, forCellReuseIdentifier: "place")
        // setup table view refresh control
        placesRefreshControl = UIRefreshControl()
        placesRefreshControl.addTarget(self, action: #selector(self.refreshPlacesTableView), forControlEvents: UIControlEvents.ValueChanged)
        placesTableView.addSubview(placesRefreshControl)
        
        setup()
        //self.displayNavBarActivity()
    }

    override func viewDidAppear(animated: Bool) {
        self.reloadPlacesTableView(self.sortingType)
        showInitialSpinnerLoad() // should show only once
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .Restricted, .Denied, .NotDetermined:
                self.LocationMgr.requestWhenInUserAuthorization()
            default:
                break
            }
        }
    }
    
    func loadInitialPlaces(){
        SwiftSpinner.show("Загрузка...")
        self.placesTableView.backgroundView = nil
        self.placesModelLogic.loadInitialPlaces() { (error: ErrorCode?) in
            if error == nil {
                self.enableTabBar()
                self.placesTableView.addSubview(self.placesRefreshControl)
                self.placesTableView.reloadData()
                self.loadedInitialPlaces = true
                self.calculateDistancesAndSort()
            }else {
                
                if error == ErrorCode.cityNotDetected {
                    // show message that user's city is not detected
                    self.placesTableView.backgroundView = self.noCityView
                }
            }
            SwiftSpinner.hide()
        }
    }
    
    // pull-down to refresh places table view
    func refreshPlacesTableView() {
        self.placesModelLogic.loadInitialPlaces { (error: ErrorCode?) in
            if error == nil {
                self.placesTableView.reloadData()
                self.placesRefreshControl.endRefreshing()
                if self.currentLocation == nil {
                    self.LocationMgr.startUpdatingLocation()
                }else {
                    self.calculateDistancesAndSort()
                }
            }else {
                if error == ErrorCode.cityNotDetected {
                    self.placesRefreshControl.endRefreshing()
                    self.placesTableView.backgroundView = self.noCityView

                }
            }
            
        }
    }
    
    // initiate distances calculation and sort ascending if sorting type is by distance
    func calculateDistancesAndSort() {
        if self.currentLocation != nil {
            self.placesModelLogic.calculateDistances(self.currentLocation!) {
                if self.sortingType == SortingType.byDistance {
                    self.placesModelLogic.sortBy(self.sortingType)
                }
                self.placesTableView.reloadData()
            }
        }
    }
    
    // MARK: - PlacesTableViewProtocol
    func reloadPlacesTableView(sortingType: SortingType, searched: Bool = false) {
        if searched && self.placesModelLogic.places.count == 0 {
            self.placesTableView.backgroundView = noPlacesFoundView
        } else {
            self.placesTableView.backgroundView = nil
            self.placesTableView.reloadData()
            self.sortingType = sortingType
            calculateDistancesAndSort()
        }
    }
    
    // MARK: - LocationProtocol
    func locationDidUpdateToLocation(location: CLLocation) {
        currentLocation = location
        self.LocationMgr.stopUpdatingLocation()
        //searchBoundary.initializeBoundaryToUserLocation(currentLocation!)

        if UserCity.city.name == nil {
            UserCity.getUserLocationCity(currentLocation!, completion: { (Void) in
                // If city is not detected, tell the user
                guard UserCity.city.name != nil else {
                    // show message that user's city is not detected
                    self.placesTableView.backgroundView = self.noCityView
                    self.disableTabBar()
                    self.placesRefreshControl.removeFromSuperview()
                    SwiftSpinner.hide()
                    return
                }
                // if city is not available, tell the user
                guard UserCity.isCityAvailable() != false else {
                    self.placesTableView.backgroundView = self.notAvailableCityView
                    self.disableTabBar()
                    self.placesRefreshControl.removeFromSuperview()
                    SwiftSpinner.hide()
                    return
                }
                // if city is detected and available, load places
                if !self.loadedInitialPlaces {
                    self.loadInitialPlaces()
                }
            
            })
        }
    
    }
    
    func locationDidFailWithError(error: NSError) {
        SwiftSpinner.hide()
        self.placesTableView.backgroundView = self.noLocationServicesView
        self.disableTabBar()
    }
    
    func showLocationServicesNotEnabledAlert(){
        let alert = UIAlertController(title: "Службы геопозиции недоступны", message: "Зайдите в Настройки->Конфиденциальность и включите служюы геолокации", preferredStyle: UIAlertControllerStyle.Alert)
        let alertAction = UIAlertAction(title: "ОК", style: UIAlertActionStyle.Default) { (action: UIAlertAction) in
            alert.dismissViewControllerAnimated(true, completion: nil)
        }
        alert.addAction(alertAction)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    // MARK: - UI
    
    var showedSpinnerOnce = false
    func showInitialSpinnerLoad(){
        if !showedSpinnerOnce {
            SwiftSpinner.show("Загрузка...")
             showedSpinnerOnce = true
        }
    }
    
    func openSearchView() {
        searchVC.placesTableViewDelegate = self
        self.navigationController?.pushViewController(searchVC, animated: false)
    }
    
    func openMapView() {
        self.navigationController?.pushViewController(mapVC, animated: true)
    }
    
    func disableTabBar(){
        self.navigationItem.rightBarButtonItems = []
    }
    
    func enableTabBar(){
        self.navigationItem.rightBarButtonItems =  [mapItem, searchItem]
    }
    
    func setup() {
        // set navigation bar title
        self.navigationItem.titleView = UIImageView(image: UIImage(named: "logo_block"))
        self.navigationItem.titleView?.tintColor = UIColor.whiteColor()
        
        // setup UINavBar items
        mapItem = UIBarButtonItem(image: UIImage(named: "map-icon"), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(self.openMapView) )
        mapItem.tintColor = UIColor.whiteColor()
        
        searchItem = UIBarButtonItem(image: UIImage(named: "search-icon"), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(self.openSearchView))
        searchItem.tintColor = UIColor.whiteColor()
        self.navigationItem.rightBarButtonItems = [mapItem, searchItem]
        
        // set back button which sends to this controler
        let backButton = UIBarButtonItem()
        //backButton.setBackButtonBackgroundImage(UIImage(named: "back"), forState: UIControlState.Normal, barMetrics: UIBarMetrics.Default)
        backButton.title = "Назад"
        backButton.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationItem.backBarButtonItem = backButton

        noPlacesFoundView = NoPlacesFound()
        noCityView = NoCityView()
        noCityView.placesTableViewDelegate = self
        
        notAvailableCityView = NotAvailableCityView()
        noLocationServicesView = NoLocationServicesView()
        noLocationServicesView.placesTableViewDelegate = self
        
        // table view
        placesTableView.separatorColor = UIColor.primaryRedColor()
        //placesTableView.layoutMargins = UIEdgeInsetsZero
        self.view.addSubview(placesTableView)
        placesTableView.snp_makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        
        
    } // END SETUP

}



