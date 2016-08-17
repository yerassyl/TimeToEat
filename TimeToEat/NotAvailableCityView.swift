//
//  NotAvailableCityView.swift
//  TimeToEat
//
//  Created by User on 15.08.16.
//  Copyright © 2016 yerassyl. All rights reserved.
//

import UIKit

class NotAvailableCityView: UIView {
    
    var cryingMiras: UIImageView!
    var notAvailableCityLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setup() {
        cryingMiras = UIImageView()
        cryingMiras.image = UIImage(named: "crying")
        self.addSubview(cryingMiras)
        
        notAvailableCityLabel = UILabel()
        notAvailableCityLabel.text = "К сожалению Время Есть не доступно в вашем городе. \n Напишите нам на vk.com/timetoeatkz, и мы добавим ваш город"
        notAvailableCityLabel.font = UIFont.getMainFont(18)
        notAvailableCityLabel.textColor = UIColor.primaryBlackColor()
        notAvailableCityLabel.textAlignment = .Center
        notAvailableCityLabel.lineBreakMode = .ByWordWrapping
        notAvailableCityLabel.numberOfLines = 0
        self.addSubview(notAvailableCityLabel)
        
        cryingMiras.snp_makeConstraints { (make) in
            make.left.equalTo(self).offset(screenWidth/2-35)
            make.top.equalTo(self).offset(screenHeight/3)
        }
        
        notAvailableCityLabel.snp_makeConstraints { (make) in
            make.left.equalTo(self).offset(20)
            make.top.equalTo(cryingMiras.snp_bottom).offset(20)
            make.right.equalTo(self).offset(-20)
        }
    }
    
}