//
//  NoLocationServicesView.swift
//  TimeToEat
//
//  Created by User on 16.08.16.
//  Copyright © 2016 yerassyl. All rights reserved.
//

import UIKit

class NoLocationServicesView: UIView {
    var noLocationServicesLabel: UILabel!
    var tryAgainbutton: UIButton!
    
    var placesTableViewDelegate: PlacesTableViewProtocol!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func tryAgainButtonPressed(){
        self.placesTableViewDelegate.loadInitialPlaces()
    }
    
    func setup(){
        noLocationServicesLabel = UILabel()
        noLocationServicesLabel.text = "Извините, нам не удалось получить ваше местоположение, \n возможно вы запретили доступ к службам геолокации. \n"
        noLocationServicesLabel.font = UIFont.getMainFont(18)
        noLocationServicesLabel.textAlignment = .Center
        noLocationServicesLabel.textColor = UIColor.primaryRedColor()
        noLocationServicesLabel.lineBreakMode = .ByWordWrapping
        noLocationServicesLabel.numberOfLines = 0
        self.addSubview(noLocationServicesLabel)
        
        tryAgainbutton = UIButton()
        tryAgainbutton.setTitle("Попробовать еще раз", forState: UIControlState.Normal)
        tryAgainbutton.titleLabel?.font = UIFont.getMainFont(18)
        tryAgainbutton.titleLabel?.textColor = UIColor.whiteColor()
        tryAgainbutton.backgroundColor = UIColor.primaryRedColor()
        tryAgainbutton.contentEdgeInsets = UIEdgeInsets(top: 10.0, left: 20.0, bottom: 10.0, right: 20.0)
        tryAgainbutton.layer.cornerRadius = 4
        self.addSubview(tryAgainbutton)
        tryAgainbutton.addTarget(self, action: #selector(self.tryAgainButtonPressed), forControlEvents: UIControlEvents.TouchUpInside)
        
        noLocationServicesLabel.snp_makeConstraints { (make) in
            make.left.equalTo(self).offset(20)
            make.top.equalTo(self).offset(screenHeight/3)
            make.right.equalTo(self).offset(-20)
        }
        
        tryAgainbutton.snp_makeConstraints { (make) in
            make.left.equalTo(self).offset(28)
            make.top.equalTo(noLocationServicesLabel.snp_bottom).offset(20)
            make.right.equalTo(self).offset(-28)
        }
    }
    
}