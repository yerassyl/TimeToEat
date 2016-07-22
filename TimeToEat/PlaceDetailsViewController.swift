//
//  PlaceDetailsViewController.swift
//  TimeToEat
//
//  Created by User on 21.07.16.
//  Copyright © 2016 yerassyl. All rights reserved.
//

import UIKit

class PlaceDetailsViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        print("presented PlaceDetailsViewController")
        
    }

    
    //MARK: - UI
    
    func setup(){
        self.view.backgroundColor = UIColor.whiteColor()
        
        let nameLabel = UILabel()
        nameLabel.text = "Pinta"
        nameLabel.textColor = UIColor.blackColor()
        self.view.addSubview(nameLabel)
        nameLabel.snp_makeConstraints { (make) in
            make.left.equalTo(self.view).offset(10)
        }
    }
    

}
