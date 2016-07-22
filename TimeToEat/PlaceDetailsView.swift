//
//  PlaceDetailsView.swift
//  TimeToEat
//
//  Created by User on 21.07.16.
//  Copyright © 2016 yerassyl. All rights reserved.
//

import Foundation

class PlaceDetailsView: UIView {
    var place: Place!
    
    // dynamic labels
    var distanceLabel: UILabel!
    var distance = "NA"
    
    // array of mode Y-coordinates (except invisible mode) in CGFloat type
    var modes = [DetailsViewMode.FullScreen,
                 DetailsViewMode.HalfScreen,
                 DetailsViewMode.SemiHide,
                 DetailsViewMode.Hide]
    var currentDetailsViewMode: DetailsViewMode = .Hide
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.whiteColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View positioning
    
    // set the position of details view to one of the modes animated
    func setDetailsViewPosition(mode: DetailsViewMode) {
        self.currentDetailsViewMode = mode
        UIView.animateWithDuration(0.25, animations: {
            self.frame = CGRectMake(0, screenHeight*mode.rawValue, screenWidth, screenHeight)
        }) { (value: Bool) in
            //
        }
    }
    
    // move details view to specified y-coordinate (distanceFromTop) without animation
    func moveDetailsView(distanceFromTop: CGFloat) {
        self.frame = CGRectMake(0, distanceFromTop, screenWidth, screenHeight)
    }
    
    func findClosestMode(yCoordinate: CGFloat) -> DetailsViewMode {
        var minDifference: CGFloat = 9999.0
        var minIndex = 0
        var i = 0
        for mode in self.modes {
            var difference = yCoordinate - mode.rawValue*screenHeight
            if difference < 0 {
                difference = -difference
            }
            if difference < minDifference {
                minDifference = difference
                minIndex = i
            }
            i += 1
        }
        return modes[minIndex]
    }
    
    // MARK: - Setup
    func setup() {
        self.backgroundColor = UIColor.whiteColor()
                
        // SETUP PLACE INFORMATION LABELS
        let nameLabel = UILabel()
        nameLabel.text = self.place.name
        nameLabel.font = UIFont.getMainFont(26)
        self.addSubview(nameLabel)
        nameLabel.snp_makeConstraints { (make) in
            make.top.equalTo(self).offset(10)
            make.left.equalTo(self).offset(28)
        }
        
        let addressLabel = UILabel()
        addressLabel.text = self.place.adress?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) // remove leading and trailing spaces
        addressLabel.textAlignment = .Left
        addressLabel.font = UIFont.getMainFont(18)
        self.addSubview(addressLabel)
        addressLabel.snp_makeConstraints { (make) in
            make.top.equalTo(nameLabel.snp_bottom).offset(2)
            make.left.equalTo(self).offset(28)
        }
        
        let distanceLabel = UILabel()
        distanceLabel.text = self.place.distanceToStr
        distanceLabel.font = UIFont.getMainFont(18)
        self.addSubview(distanceLabel)
        distanceLabel.snp_makeConstraints { (make) in
            make.top.equalTo(addressLabel.snp_bottom).offset(2)
            make.left.equalTo(self).offset(28)
        }
        
        let lunchType = UILabel()
        lunchType.text = self.place.lunchType
        lunchType.font = UIFont.getMainFont(18)
        lunchType.textColor = UIColor.primaryRedColor()
        self.addSubview(lunchType)
        lunchType.snp_makeConstraints { (make) in
            make.left.equalTo(self).offset(28)
            make.top.equalTo(distanceLabel.snp_bottom).offset(8)
        }
        
        let priceLabel = UILabel()
        priceLabel.text = "\(self.place.lunchPrice) ₸"
        priceLabel.font = UIFont.getMainFont(48)
        priceLabel.textColor = UIColor.primaryDarkerRedColor()
        self.addSubview(priceLabel)
        priceLabel.snp_makeConstraints { (make) in
            make.top.equalTo(lunchType.snp_bottom)
            make.left.equalTo(self).offset(28)
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
        self.addSubview(callUsButton)
        callUsButton.snp_makeConstraints { (make) in
            make.left.equalTo(self).offset(44)
            make.top.equalTo(priceLabel.snp_bottom).offset(12)
            make.right.equalTo(self).offset(-44)
            make.height.equalTo(44)
        }
        callUsButton.addTarget(self, action: #selector(self.place.call), forControlEvents: UIControlEvents.TouchUpInside)
        
    }// END SETUP
    
}