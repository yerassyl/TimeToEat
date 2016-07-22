//
//  PlaceViewController.swift
//  TimeToEat
//
//  Created by User on 12.07.16.
//  Copyright © 2016 yerassyl. All rights reserved.
//

import UIKit
import Mapbox
import AlamofireObjectMapper

class PlaceViewController: UIViewController, LocationProtocol {
    
    var place: Place!
    var distanceLabel: UILabel!
    var distance = "NA"
    
    var map: MGLMapView!
    var currentLocation = CLLocation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        setup()
        
        let LocationMgr = Location.SharedManager
        LocationMgr.delegate = self
        LocationMgr.startUpdatingLocation()
        print("show place")
    }
    
    // MARK: - Actions
    func call() {
        let phone = self.place.getFirstPhone()
        if let url = NSURL(string: "tel://\(phone)") {
            UIApplication.sharedApplication().openURL(url)
        }
    }
    
    // MARK: - Location Protocol
    func locationDidUpdateToLocation(location: CLLocation) {
        self.currentLocation = location
    }
    
    // MARK: - UI Updates
    
    func updateDistanceLabel(distance: String) {
        self.distanceLabel.text = distance
    }
    
    func setup() {
        self.navigationItem.title = "ВРЕМЯ ЕСТЬ"
        self.navigationItem.titleView?.tintColor = UIColor.whiteColor()

        let navbarHeight = self.navigationController?.navigationBar.frame.height
        let mapHeight = screenHeight/2
        
        // SETUP MAP
        map = MGLMapView(frame: CGRectMake(0.0, navbarHeight!, screenWidth, mapHeight), styleURL: MGLStyle.streetsStyleURLWithVersion(9))
        map.zoomEnabled = false
        map.scrollEnabled = true
        map.rotateEnabled = true
        map.userTrackingMode = .None // do not follow
        map.showsUserLocation = true
        
        map.setCenterCoordinate(CLLocationCoordinate2D(latitude: self.place.lat,longitude: self.place.lon ), zoomLevel: 15.0, animated: false)
        self.view.addSubview(map)
        //map.delegate = self
        
        let hello = MGLPointAnnotation()
        hello.coordinate = CLLocationCoordinate2D(latitude: self.place.lat, longitude: self.place.lon)
        hello.title = "Hello world!"
        hello.subtitle = "Welcome to my marker"
        map.addAnnotation(hello)
        
        // SETUP PLACE INFORMATION LABELS
        let nameLabel = UILabel()
        nameLabel.text = self.place.name
        nameLabel.font = UIFont.getMainFont(26)
        self.view.addSubview(nameLabel)
        nameLabel.snp_makeConstraints { (make) in
            make.top.equalTo(self.view).offset(mapHeight+navbarHeight!+10)
            make.left.equalTo(self.view).offset(28)
        }
        
        let addressLabel = UILabel()
        addressLabel.text = self.place.adress?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) // remove leading and trailing spaces
        addressLabel.textAlignment = .Left
        addressLabel.font = UIFont.getMainFont(18)
        self.view.addSubview(addressLabel)
        addressLabel.snp_makeConstraints { (make) in
            make.top.equalTo(nameLabel.snp_bottom).offset(2)
            make.left.equalTo(self.view).offset(28)
        }
        
//        let distancePin = UIImageView()
//        distancePin.image = UIImage(named: "distance-pin")
//        self.view.addSubview(distancePin)
//        distancePin.snp_makeConstraints { (make) in
//            make.left.equalTo(self.view).offset(33)
//            make.top.equalTo(addressLabel.snp_bottom).offset(2)
//        }
        
        distanceLabel = UILabel()
        distanceLabel.text = self.distance
        distanceLabel.font = UIFont.getMainFont(18)
        self.view.addSubview(distanceLabel)
        distanceLabel.snp_makeConstraints { (make) in
            make.top.equalTo(addressLabel.snp_bottom).offset(2)
            make.left.equalTo(self.view).offset(28)
        }
        
        let lunchType = UILabel()
        lunchType.text = self.place.lunchType
        lunchType.font = UIFont.getMainFont(18)
        lunchType.textColor = UIColor.primaryRedColor()
        self.view.addSubview(lunchType)
        lunchType.snp_makeConstraints { (make) in
            make.left.equalTo(self.view).offset(28)
            make.top.equalTo(distanceLabel.snp_bottom).offset(8)
        }
        
        let priceLabel = UILabel()
        priceLabel.text = "\(self.place.lunchPrice) ₸"
        priceLabel.font = UIFont.getMainFont(48)
        priceLabel.textColor = UIColor.primaryDarkerRedColor()
        self.view.addSubview(priceLabel)
        priceLabel.snp_makeConstraints { (make) in
            make.top.equalTo(lunchType.snp_bottom)
            make.left.equalTo(self.view).offset(28)
        }
        
/*
        let toChoseLabel = UILabel()
        toChoseLabel.text = "На выбор"
        toChoseLabel.font = UIFont.getMainFont(16)
        self.view.addSubview(toChoseLabel)
        toChoseLabel.snp_makeConstraints { (make) in
            make.top.equalTo(priceLabel.snp_bottom).offset(1)
            make.left.equalTo(self.view).offset(28)
        }
        
        let choicesLabel = UILabel()
        choicesLabel.text = self.place.choices?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) // remove leading and trailing spaces
        choicesLabel.font = UIFont.getMainFont(16)
        choicesLabel.textColor = UIColor.secondaryGreyColor()
        choicesLabel.lineBreakMode = .ByWordWrapping
        choicesLabel.numberOfLines = 0
        self.view.addSubview(choicesLabel)
        choicesLabel.snp_makeConstraints { (make) in
            make.top.equalTo(toChoseLabel.snp_bottom).offset(1)
            make.left.equalTo(self.view).offset(28)
            make.right.equalTo(self.view).offset(-28)
        }
 */
        
        guard self.place.getFirstPhone() != "NA" else {
            return
        }
        let callUsButton = UIButton()
        callUsButton.setTitle("Позвонить", forState: UIControlState.Normal)
        callUsButton.titleLabel?.font = UIFont.getMainFont(18)
        callUsButton.titleLabel?.textColor = UIColor.whiteColor()
        callUsButton.tintColor = UIColor.whiteColor()
        callUsButton.backgroundColor = UIColor.primaryRedColor()
        callUsButton.contentEdgeInsets = UIEdgeInsets(top: 10.0, left: 20.0, bottom: 10.0, right: 20.0)
        callUsButton.layer.cornerRadius = 4
        self.view.addSubview(callUsButton)
        callUsButton.snp_makeConstraints { (make) in
            make.left.equalTo(self.view).offset(44)
            make.top.equalTo(priceLabel.snp_bottom).offset(12)
            make.right.equalTo(self.view).offset(-44)
            make.height.equalTo(44)
        }
        callUsButton.addTarget(self, action: #selector(self.call), forControlEvents: UIControlEvents.TouchUpInside)
        
        
    }// END SETUP
    

}
