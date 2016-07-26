//
//  SearchView.swift
//  TimeToEat
//
//  Created by User on 25.07.16.
//  Copyright © 2016 yerassyl. All rights reserved.
//

import Foundation

class SearchView: UIView {
    // get singleton model class to work with logic
    let placesModelLogic = PlacesLogic.PlacesLogicSingleton

    
    var nameTextField = UITextField()
    var priceSegmentedControl = UISegmentedControl()
    var distanceSegmentedControl = UISegmentedControl()
    
    var placesTableViewDelegate: PlacesTableViewProtocol!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        self.hidden = true
        
        // delegate depends on which class initiated search view open
        // MainViewController or MapViewController
        placesTableViewDelegate = MainViewController()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func search() {
        let name = nameTextField.text!
        
        var priceFrom = 0
        var priceTo = 99999
        var distanceFrom = 0.0
        var distanceTo = 9999.0
        
        let priceSegmentIndex = priceSegmentedControl.selectedSegmentIndex
        let distanceSegmentIndex = distanceSegmentedControl.selectedSegmentIndex
        
        switch priceSegmentIndex {
        case 0:
            priceTo = 1000
        case 1:
            priceFrom = 1000
            priceTo = 2000
        case 2:
            priceFrom = 2000
        default: break
        }
        
        switch distanceSegmentIndex {
        case 0:
            distanceTo = 500.0
        case 1:
            distanceFrom = 500.0
            distanceTo = 1000.0
        case 2:
            distanceFrom = 1000.0
        default: break
        }
        
        self.placesModelLogic.searchPlaces(name, priceFrom: priceFrom, priceTo: priceTo, distanceFrom: distanceFrom, distanceTo: distanceTo) { (Void) in
            // close search view
            self.closeSearchView({ (Void) in
                print("completed")
            })
        }
    }
    
    
    // MARK: UI
    func openSearchView() {
        self.hidden = false
    }
    
    func closeSearchView(completion: (Void) -> Void ) {
        //self.
        //UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            self.hidden = true
        //}) { (animated: Bool) in
        //    if animated {
                print("print right before ")
                completion()
        //    }
            
        //}
        
    }
    
    
    func setup() {
        self.backgroundColor = UIColor.whiteColor()
        
        // По названию
        let nameLabel = UILabel()
        nameLabel.text = "По Названию"
        nameLabel.font = UIFont.getMainFont(18)
        nameLabel.textColor = UIColor.primaryDarkerRedColor()
        self.addSubview(nameLabel)
        nameLabel.snp_makeConstraints { (make) in
            make.left.equalTo(self).offset(10)
            make.top.equalTo(self).offset(12)
        }
        
        nameTextField = UITextField()
        nameTextField.placeholder = "Введите название..."
        self.addSubview(nameTextField)
        nameTextField.snp_makeConstraints { (make) in
            make.left.equalTo(self).offset(10)
            make.top.equalTo(nameLabel.snp_bottom).offset(12)
        }
        
        // По Категориям
        let categoriesLabel = UILabel()
        categoriesLabel.text = "По категориям"
        categoriesLabel.font = UIFont.getMainFont(18)
        categoriesLabel.textColor = UIColor.primaryDarkerRedColor()
        self.addSubview(categoriesLabel)
        categoriesLabel.snp_makeConstraints { (make) in
            make.left.equalTo(self).offset(10)
            make.top.equalTo(nameTextField.snp_bottom).offset(12)
        }
        
        // Стоимость
        let priceLabel = UILabel()
        priceLabel.text = "Стоимость"
        priceLabel.font = UIFont.getMainFont(18)
        priceLabel.textColor = UIColor.primaryBlackColor()
        priceLabel.textAlignment = NSTextAlignment.Center
        self.addSubview(priceLabel)
        priceLabel.snp_makeConstraints { (make) in
            make.left.equalTo(self).offset(10)
            make.top.equalTo(categoriesLabel.snp_bottom).offset(12)
            make.right.equalTo(self).offset(-10)
        }
        
        
        priceSegmentedControl = UISegmentedControl()
        priceSegmentedControl.tintColor = UIColor.primaryRedColor()
        priceSegmentedControl.insertSegmentWithTitle("До 1000 ₸", atIndex: 0, animated: false)
        priceSegmentedControl.insertSegmentWithTitle("1000₸-2000₸", atIndex: 1, animated: false)
        priceSegmentedControl.insertSegmentWithTitle("От 2000₸", atIndex: 2, animated: false)
        self.addSubview(priceSegmentedControl)
        priceSegmentedControl.snp_makeConstraints { (make) in
            make.left.equalTo(self).offset(10)
            make.top.equalTo(priceLabel.snp_bottom).offset(12)
        }
        
        // Растояние
        let distanceLabel = UILabel()
        distanceLabel.text = "Растояние"
        distanceLabel.font = UIFont.getMainFont(18)
        distanceLabel.textColor = UIColor.primaryBlackColor()
        distanceLabel.textAlignment = NSTextAlignment.Center
        self.addSubview(distanceLabel)
        distanceLabel.snp_makeConstraints { (make) in
            make.left.equalTo(self).offset(10)
            make.top.equalTo(priceSegmentedControl.snp_bottom).offset(12)
            make.right.equalTo(self).offset(-10)
        }
        
        distanceSegmentedControl = UISegmentedControl()
        distanceSegmentedControl.tintColor = UIColor.primaryRedColor()
        distanceSegmentedControl.insertSegmentWithTitle("До 500 м", atIndex: 0, animated: false)
        distanceSegmentedControl.insertSegmentWithTitle("500м - 1км", atIndex: 1, animated: false)
        distanceSegmentedControl.insertSegmentWithTitle("От 1км", atIndex: 2, animated: false)
        self.addSubview(distanceSegmentedControl)
        distanceSegmentedControl.snp_makeConstraints { (make) in
            make.left.equalTo(self).offset(10)
            make.top.equalTo(distanceLabel.snp_bottom).offset(12)
        }
        
        // НАЙТИ
        let findButton = UIButton()
        findButton.setTitle("Найти", forState: UIControlState.Normal)
        findButton.backgroundColor = UIColor.primaryRedColor()
        findButton.titleLabel?.font = UIFont.getMainFont(18)
        findButton.titleLabel?.textColor = UIColor.whiteColor()
        findButton.contentEdgeInsets = UIEdgeInsets(top: 10.0, left: 20.0, bottom: 10.0, right: 20.0)
        findButton.layer.cornerRadius = 4
        self.addSubview(findButton)
        findButton.snp_makeConstraints { (make) in
            make.left.equalTo(self).offset(10)
            make.top.equalTo(distanceSegmentedControl.snp_bottom).offset(26)
            make.right.equalTo(self).offset(-10)
        }
        findButton.addTarget(self, action: #selector(self.search), forControlEvents: UIControlEvents.TouchUpInside)
        
        
    }

    
}