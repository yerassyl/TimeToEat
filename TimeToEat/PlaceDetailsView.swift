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
    
    var sepLine = UIImageView()
    // static labels
    var nameLabel = UILabel()
    var addressLabel = UILabel()
    var lunchType = UILabel()
    var distanceLabel = UILabel()
    var priceLabel = UILabel()
    var callUsButton = UIButton()
    var cousineLabel = UILabel()
    var workignHoursLabel = UILabel()
    var featuresLabel = UILabel()
    var choisesLabel = UILabel()
    
    var lineSeperatorImageView1 = UIImageView()
    var lineSeperatorImageView2 = UIImageView()
    
    // array of mode Y-coordinates (except invisible mode) in CGFloat type
    var modes = [DetailsViewMode.FullScreen,
                 DetailsViewMode.HalfScreen,
                 DetailsViewMode.SemiHide,
                 DetailsViewMode.Hide,
                 DetailsViewMode.Invisible]
    
    var currentDetailsViewMode: DetailsViewMode = .Invisible
    
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
        var topMargin = screenHeight*mode.rawValue
        if mode == DetailsViewMode.FullScreen {
            topMargin = navbarHeight
        }
        
        UIView.animateWithDuration(0.25, animations: {
            self.frame = CGRectMake(0, topMargin, screenWidth, screenHeight)
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
    
    func callButtonPressed(){
        UIView.animateWithDuration(0.3) { 
            self.callUsButton.alpha = 0.5
        }
        self.callUsButton.enabled = false
        self.place.call(){
            print("call completion")
            UIView.animateWithDuration(0.3, animations: { 
                self.callUsButton.enabled = true
            })
            
            self.callUsButton.alpha = 1.0
        }
    }
    
    // MARK: - UI
    
    func setStaticLabels(){
        nameLabel.text = self.place.name
        addressLabel.text = self.place.adress?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) // remove leading and trailing spaces
        distanceLabel.text = self.place.distanceToStr
        lunchType.text = self.place.lunchType
        priceLabel.text = "\(self.place.lunchPrice) ₸"
        cousineLabel.text = self.place.cousine
        workignHoursLabel.text = self.place.workingHours
        featuresLabel.text = self.place.features
        choisesLabel.text = self.place.choices?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) // remove leading and trailing spaces

        guard self.place.getFirstPhone() != "NA" else {
            return
        }
        callUsButton.backgroundColor = UIColor.primaryRedColor()
        callUsButton.enabled = true
    }

    func setup() {
        self.backgroundColor = UIColor.whiteColor()
        
        sepLine.image = UIImage(named: "line")
        self.addSubview(sepLine)
        
        // SETUP PLACE INFORMATION LABELS
        nameLabel.font = UIFont.getMainFont(26)
        self.addSubview(nameLabel)
        
        addressLabel.textAlignment = .Left
        addressLabel.font = UIFont.getMainFont(18)
        self.addSubview(addressLabel)
        
        distanceLabel.font = UIFont.getMainFont(18)
        self.addSubview(distanceLabel)
        
        lunchType.font = UIFont.getMainFont(18)
        lunchType.textColor = UIColor.primaryRedColor()
        self.addSubview(lunchType)
        
        priceLabel.font = UIFont.getMainFont(48)
        priceLabel.textColor = UIColor.primaryDarkerRedColor()
        self.addSubview(priceLabel)
        
        callUsButton.setTitle("Позвонить", forState: UIControlState.Normal)
        callUsButton.titleLabel?.font = UIFont.getMainFont(18)
        callUsButton.titleLabel?.textColor = UIColor.whiteColor()
        callUsButton.tintColor = UIColor.whiteColor()
        callUsButton.backgroundColor = UIColor.secondaryGreyColor()
        callUsButton.contentEdgeInsets = UIEdgeInsets(top: 10.0, left: 20.0, bottom: 10.0, right: 20.0)
        callUsButton.layer.cornerRadius = 4
        callUsButton.enabled = false
        self.addSubview(callUsButton)
        callUsButton.addTarget(self, action: #selector(self.callButtonPressed), forControlEvents: UIControlEvents.TouchUpInside)
        
        cousineLabel.font = UIFont.getMainFont(18)
        cousineLabel.textColor = UIColor.primaryBlackColor()
        cousineLabel.lineBreakMode = .ByWordWrapping
        cousineLabel.numberOfLines = 0
        cousineLabel.textAlignment = .Center
        self.addSubview(cousineLabel)
        
        lineSeperatorImageView1.image = UIImage(named: "line")
        self.addSubview(lineSeperatorImageView1)
        lineSeperatorImageView2.image = UIImage(named: "line")
        self.addSubview(lineSeperatorImageView2)
        
        workignHoursLabel.font = UIFont.getMainFont(18)
        workignHoursLabel.textColor = UIColor.primaryBlackColor()
        workignHoursLabel.textAlignment = .Center
        self.addSubview(workignHoursLabel)
        
        featuresLabel.font = UIFont.getMainFont(18)
        featuresLabel.textColor = UIColor.primaryBlackColor()
        featuresLabel.textAlignment = .Center
        featuresLabel.lineBreakMode = .ByWordWrapping
        featuresLabel.numberOfLines = 0
        self.addSubview(featuresLabel)
        
        choisesLabel.font = UIFont.getMainFont(18)
        choisesLabel.textColor = UIColor.primaryBlackColor()
        choisesLabel.textAlignment = .Center
        choisesLabel.lineBreakMode = .ByWordWrapping
        choisesLabel.numberOfLines = 0
        self.addSubview(choisesLabel)
        
        sepLine.snp_remakeConstraints { (make) in
            make.left.equalTo(self).offset(screenWidth/2-10)
            make.top.equalTo(self).offset(8)
            make.right.equalTo(self).offset(-(screenWidth/2-10))
        }
        nameLabel.snp_remakeConstraints { (make) in
            make.top.equalTo(sepLine.snp_bottom).offset(8)
            make.left.equalTo(self).offset(28)
        }
        
        addressLabel.snp_remakeConstraints { (make) in
            make.top.equalTo(nameLabel.snp_bottom).offset(1)
            make.left.equalTo(self).offset(28)
        }
        
        distanceLabel.snp_remakeConstraints { (make) in
            make.top.equalTo(addressLabel.snp_bottom).offset(2)
            make.left.equalTo(self).offset(28)
        }
        
        lunchType.snp_remakeConstraints { (make) in
            make.left.equalTo(self).offset(28)
            make.top.equalTo(distanceLabel.snp_bottom).offset(6)
        }
        
        priceLabel.snp_remakeConstraints { (make) in
            make.top.equalTo(lunchType.snp_bottom).offset(-4)
            make.left.equalTo(self).offset(28)
        }
        
        callUsButton.snp_remakeConstraints { (make) in
            make.left.equalTo(self).offset(28)
            make.top.equalTo(priceLabel.snp_bottom).offset(8)
            make.right.equalTo(self).offset(-28)
            make.height.equalTo(44)
        }
        
        cousineLabel.snp_remakeConstraints { (make) in
            make.left.equalTo(self).offset(30)
            make.right.equalTo(self).offset(-30)
            make.top.equalTo(callUsButton.snp_bottom).offset(25)
        }
        
        lineSeperatorImageView1.snp_remakeConstraints { (make) in
            make.left.equalTo(self).offset(146)
            make.right.equalTo(self).offset(-146)
            make.top.equalTo(cousineLabel.snp_bottom).offset(17)
        }
        
        workignHoursLabel.snp_remakeConstraints { (make) in
            make.left.equalTo(self).offset(30)
            make.right.equalTo(self).offset(-30)
            make.top.equalTo(lineSeperatorImageView1.snp_bottom).offset(14)
        }
        
        lineSeperatorImageView2.snp_remakeConstraints { (make) in
            make.left.equalTo(self).offset(146)
            make.right.equalTo(self).offset(-146)
            make.top.equalTo(workignHoursLabel.snp_bottom).offset(17)
        }
        
        choisesLabel.snp_remakeConstraints { (make) in
            make.left.equalTo(self).offset(30)
            make.right.equalTo(self).offset(-30)
            make.top.equalTo(lineSeperatorImageView2.snp_bottom).offset(14)
        }
        
    }// END SETUP
    
    
    
}