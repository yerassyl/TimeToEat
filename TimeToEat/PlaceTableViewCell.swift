//
//  PlaceTableViewCell.swift
//  TimeToEat
//
//  Created by User on 07.07.16.
//  Copyright © 2016 yerassyl. All rights reserved.
//

import UIKit

class PlaceTableViewCell: UITableViewCell {

    var placeImageView: UIImageView!
    var nameLabel: UILabel!
    
    var businessLunchLabel: UILabel!
    var businessLunchPriceLabel: UILabel!
    
    var businessLucnhTimeLabel: UILabel!
    
    var distanceToLabel: UILabel!
    var distanceToImage: UIImageView!
    
    var workingHoursLabel: UILabel!
    var clockIcon: UIImageView!
    
    var cellHeight = 0.0
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setup() {
        placeImageView = UIImageView()
        placeImageView.image = UIImage(named: "placeholder")
        contentView.addSubview(placeImageView)
        
        nameLabel = UILabel()
        nameLabel.text = "Загрузка..."
        nameLabel.font = UIFont.getMainFont(20)
        
        contentView.addSubview(nameLabel)
        
        distanceToLabel = UILabel()
        distanceToLabel.text = "Загрузка..."
        distanceToLabel.font = UIFont.getMainFont(13)
        contentView.addSubview(distanceToLabel)
        
        businessLunchLabel = UILabel()
        businessLunchLabel.text = "бизнес-ланч"
        businessLunchLabel.font = UIFont.getMainFont(12)
        businessLunchLabel.textColor = UIColor.primaryRedColor()
        contentView.addSubview(businessLunchLabel)
        
        businessLunchPriceLabel = UILabel()
        businessLunchPriceLabel.text = "0T"
        businessLunchPriceLabel.font = UIFont.getMainFont(40)
        businessLunchPriceLabel.textColor = UIColor.primaryDarkerRedColor()
        contentView.addSubview(businessLunchPriceLabel)
        
        let cellBottomLine = UIView(frame: CGRect(x: 19.0, y: self.cellHeight, width: Double(screenWidth), height: 1.0) )
        cellBottomLine.backgroundColor = UIColor.secondaryGreyColor()
        contentView.addSubview(cellBottomLine)
        
        updateConstraints()
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        placeImageView.snp_makeConstraints { (make) -> Void in
            make.height.width.equalTo(134)
            make.right.equalTo(self.snp_right)
        }
        
        nameLabel.snp_makeConstraints { (make) in
            make.left.equalTo(self.contentView).offset(19)
            make.top.equalTo(self.contentView).offset(15)
        }
        
        distanceToLabel.snp_makeConstraints { (make) in
            make.left.equalTo(self.contentView).offset(17)
            make.top.equalTo(nameLabel.snp_bottom).offset(1)
        }
        
        businessLunchLabel.snp_makeConstraints { (make) in
            make.left.equalTo(self.contentView).offset(19)
            make.top.equalTo(distanceToLabel.snp_bottom).offset(12)
        }
        
        businessLunchPriceLabel.snp_makeConstraints { (make) in
            make.left.equalTo(self.contentView).offset(19)
            make.top.equalTo(businessLunchLabel.snp_bottom).offset(-6)
        }

        
    }
    
}
