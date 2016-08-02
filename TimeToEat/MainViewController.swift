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

var screenWidth: CGFloat!
var screenHeight: CGFloat!
var navbarHeight: CGFloat! // actually navbar height + statusbar height

protocol PlacesTableViewProtocol {
    func reloadPlacesTableView(sortingType: SortingType, searched: Bool )
}


class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, LocationProtocol, PlacesTableViewProtocol {
    // get singleton model class to work with logic
    let placesModelLogic = PlacesLogic.PlacesLogicSingleton
    var sortingType = SortingType.byDistance
    // get location singleton class to work with location logic
    let LocationMgr = Location.SharedManager
    
    var placesTableView: UITableView!
    var placesRefreshControl: UIRefreshControl!
    var nothingFoundLabel: UILabel!
    
    var mapItem: UIBarButtonItem!
    var searchItem: UIBarButtonItem!
    
    var currentLocation: CLLocation?
    
    // ViewControllers to be pushed 
    let mapVC = MapViewController()
    let searchVC = SearchViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        self.LocationMgr.delegate = self
        self.displayNavBarActivity()
        placesModelLogic.loadInitialPlaces() {
            self.dismissNavBarActivity()
            self.placesTableView.reloadData()
            self.LocationMgr.requestLocationOnce()
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        self.reloadPlacesTableView(self.sortingType)
    }
    
    
    // pull-down to refresh places table view
    func refreshPlacesTableView() {
        self.placesModelLogic.loadInitialPlaces { (Void) in
            self.placesTableView.reloadData()
            self.placesRefreshControl.endRefreshing()
            if self.currentLocation == nil {
                self.LocationMgr.requestLocationOnce()
            }else {
                self.calculateDistancesAndSort()
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
            self.placesTableView.backgroundView = nothingFoundLabel
        } else {
            self.placesTableView.reloadData()
            self.sortingType = sortingType
            calculateDistancesAndSort()
        }
        
    }
    
    // MARK: - LocationProtocol
    func locationDidUpdateToLocation(location: CLLocation) {
        currentLocation = location
        // should run only once initially
        calculateDistancesAndSort()
    }
    
    // MARK: - Table View
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.placesModelLogic.places.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("place", forIndexPath: indexPath) as! PlaceTableViewCell
        
        let currentPlace = self.placesModelLogic.places[indexPath.row]
        
        if currentPlace.placeImage != nil {
            cell.placeImageView?.kf_setImageWithURL(NSURL(string: currentPlace.placeImage!)!, placeholderImage: UIImage(named:"placeholder") )
        }
        
        cell.nameLabel.text = currentPlace.name
        cell.businessLunchLabel.text = currentPlace.lunchType
        cell.businessLunchPriceLabel.text = "\(currentPlace.lunchPrice) ₸"
        
        cell.distanceToLabel.text = currentPlace.distanceToStr
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.cellHeight = 134.0
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        // calculate cell width
        //let cellWidth = tableView.frame.height/5
        return 134
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectedPlace = self.placesModelLogic.places[indexPath.row]
        mapVC.mapSelectedPlace = selectedPlace
        self.navigationController?.pushViewController(mapVC, animated: true)
    }
    
    // MARK: - UI
    
    func openSearchView() {
        searchVC.placesTableViewDelegate = self
        self.navigationController?.pushViewController(searchVC, animated: false)
    }
    
    func openMapView() {
        self.navigationController?.pushViewController(mapVC, animated: true)
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

        
        // set nothing found label
        nothingFoundLabel = UILabel()
        nothingFoundLabel.frame = CGRect(x: 0, y: screenHeight/2, width: screenWidth, height: 44)
        nothingFoundLabel.textAlignment = .Center
        nothingFoundLabel.text = "Ничего не найдено"
        nothingFoundLabel.font = UIFont.getMainFont(18)
        nothingFoundLabel.textColor = UIColor.primaryRedColor()
        //nothingFoundLabel.hidden = true
//        nothingFoundLabel.snp_makeConstraints { (make) in
//            make.left.equalTo(self.view).offset(20)
//            make.top.equalTo(self.view).offset(navbarHeight+20)
//            make.right.equalTo(self.view).offset(-20)
//        }
        
        // table view
        placesTableView.separatorColor = UIColor.primaryRedColor()
        //placesTableView.layoutMargins = UIEdgeInsetsZero
        self.view.addSubview(placesTableView)
        placesTableView.snp_makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        
        
    } // END SETUP

}
