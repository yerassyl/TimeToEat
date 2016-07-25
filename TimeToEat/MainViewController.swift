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

class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, LocationProtocol {
    // get singleton model class to work with logic
    let placesModelLogic = PlacesLogic.PlacesLogicSingleton

    var placesTableView: UITableView!
    var currentLocation = CLLocation()
    
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
        setup()
        
        self.displayNavBarActivity()
        placesModelLogic.loadInitialPlaces() {
            self.dismissNavBarActivity()
            self.placesTableView.reloadData()
            let LocationMgr = Location.SharedManager
            LocationMgr.delegate = self
        }

    }
    
    // MARK: - LocationProtocol
    func locationDidUpdateToLocation(location: CLLocation) {
        currentLocation = location
        // should run only once initially
        self.placesModelLogic.calculateDistances(self.currentLocation) {
            self.placesModelLogic.places.sortInPlace({ (s1: Place, s2: Place) -> Bool in
                return s1.distanceToDouble < s2.distanceToDouble
            })
            self.placesTableView.reloadData()
        }
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
        // add bottom border
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
        
        // Bete Functionality
//        let placeVC = PlaceViewController()
//        placeVC.place = selectedPlace
//        
//        let selectedCell = tableView.cellForRowAtIndexPath(indexPath) as! PlaceTableViewCell
//        placeVC.distance = selectedCell.distanceToLabel.text!
//        self.navigationController?.pushViewController(placeVC, animated: true)
// 
        
        let mapVC = MapViewController()
        mapVC.mapSelectedPlace = selectedPlace
        self.navigationController?.pushViewController(mapVC, animated: true)
    }
    
    // MARK: - UI
    
    func openMapView() {
        let mapVC = MapViewController()
        self.navigationController?.pushViewController(mapVC, animated: true)
    }
    
    func setup() {
        // set navigation bar title
        self.navigationItem.titleView = UIImageView(image: UIImage(named: "logo_block"))
        self.navigationItem.titleView?.tintColor = UIColor.whiteColor()
        
        // setup UINavBar items
        let mapItem = UIBarButtonItem(image: UIImage(named: "map-icon"), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(self.openMapView) )
        let searchItem = UIBarButtonItem(image: UIImage(named: "search-icon"), style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        mapItem.tintColor = UIColor.whiteColor()
        searchItem.tintColor = UIColor.whiteColor()
        self.navigationItem.rightBarButtonItems = [mapItem, searchItem]
        
        // set back button which sends to this controler
        let backButton = UIBarButtonItem()
        //backButton.setBackButtonBackgroundImage(UIImage(named: "back"), forState: UIControlState.Normal, barMetrics: UIBarMetrics.Default)
        backButton.title = "Назад"
        backButton.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationItem.backBarButtonItem = backButton
        
        // table view
        placesTableView.separatorColor = UIColor.primaryRedColor()
        //placesTableView.layoutMargins = UIEdgeInsetsZero
        self.view.addSubview(placesTableView)
        placesTableView.snp_makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        
    } // END SETUP
    

}
