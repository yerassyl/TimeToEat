//
//  NoPlacesFound.swift
//  TimeToEat
//
//  Created by User on 11.08.16.
//  Copyright © 2016 yerassyl. All rights reserved.
//

import UIKit

class NoPlacesFound: UIView {
    var nothingFoundLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(){
        nothingFoundLabel = UILabel()
        nothingFoundLabel.frame = CGRect(x: 0, y: screenHeight/2, width: screenWidth, height: 44)
        nothingFoundLabel.textAlignment = .Center
        nothingFoundLabel.text = "Ничего не найдено"
        nothingFoundLabel.font = UIFont.getMainFont(18)
        nothingFoundLabel.textColor = UIColor.primaryRedColor()
        self.addSubview(nothingFoundLabel)
        nothingFoundLabel.snp_makeConstraints { (make) in
            make.left.equalTo(self).offset(20)
            make.right.equalTo(self).offset(-20)
            make.top.equalTo(self).offset(screenHeight/2)
        }
        
    }
    
}