//
//  SearchViewController.swift
//  TimeToEat
//
//  Created by User on 26.07.16.
//  Copyright © 2016 yerassyl. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    // get singleton model class to work with logic
    let placesModelLogic = PlacesLogic.PlacesLogicSingleton
    
    
    var nameTextField = UITextField()
    var priceSegmentedControl = UISegmentedControl()
    var distanceSegmentedControl = UISegmentedControl()
    
    var placesTableViewDelegate: PlacesTableViewProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        // set navigation bar title
        self.navigationItem.titleView = UIImageView(image: UIImage(named: "logo_block"))
        self.navigationItem.titleView?.tintColor = UIColor.whiteColor()
        
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(title: "Отмена", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(self.pop))]
        
        setup()

    }
    
    func pop() {
        self.navigationController?.popViewControllerAnimated(true)
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
            self.placesTableViewDelegate.reloadPlacesTableView()
            self.navigationController?.popViewControllerAnimated(false)
        }
        
    }
    
    
    // MARK: UI
    
    func setup() {
        
        // По названию
        let nameLabel = UILabel()
        nameLabel.text = "По Названию"
        nameLabel.font = UIFont.getMainFont(18)
        nameLabel.textColor = UIColor.primaryDarkerRedColor()
        self.view.addSubview(nameLabel)
        nameLabel.snp_makeConstraints { (make) in
            make.left.equalTo(self.view).offset(10)
            make.top.equalTo(self.view).offset(navbarHeight+12)
        }
        
        nameTextField = UITextField()
        nameTextField.placeholder = "Введите название..."
        self.view.addSubview(nameTextField)
        nameTextField.snp_makeConstraints { (make) in
            make.left.equalTo(self.view).offset(10)
            make.top.equalTo(nameLabel.snp_bottom).offset(12)
        }
        
        // По Категориям
        let categoriesLabel = UILabel()
        categoriesLabel.text = "По категориям"
        categoriesLabel.font = UIFont.getMainFont(18)
        categoriesLabel.textColor = UIColor.primaryDarkerRedColor()
        self.view.addSubview(categoriesLabel)
        categoriesLabel.snp_makeConstraints { (make) in
            make.left.equalTo(self.view).offset(10)
            make.top.equalTo(nameTextField.snp_bottom).offset(12)
        }
        
        // Стоимость
        let priceLabel = UILabel()
        priceLabel.text = "Стоимость"
        priceLabel.font = UIFont.getMainFont(18)
        priceLabel.textColor = UIColor.primaryBlackColor()
        priceLabel.textAlignment = NSTextAlignment.Center
        self.view.addSubview(priceLabel)
        priceLabel.snp_makeConstraints { (make) in
            make.left.equalTo(self.view).offset(10)
            make.top.equalTo(categoriesLabel.snp_bottom).offset(12)
            make.right.equalTo(self.view).offset(-10)
        }
        
        
        priceSegmentedControl = UISegmentedControl()
        priceSegmentedControl.tintColor = UIColor.primaryRedColor()
        priceSegmentedControl.insertSegmentWithTitle("До 1000 ₸", atIndex: 0, animated: false)
        priceSegmentedControl.insertSegmentWithTitle("1000₸-2000₸", atIndex: 1, animated: false)
        priceSegmentedControl.insertSegmentWithTitle("От 2000₸", atIndex: 2, animated: false)
        self.view.addSubview(priceSegmentedControl)
        priceSegmentedControl.snp_makeConstraints { (make) in
            make.left.equalTo(self.view).offset(10)
            make.top.equalTo(priceLabel.snp_bottom).offset(12)
        }
        
        // Растояние
        /*
        let distanceLabel = UILabel()
        distanceLabel.text = "Растояние"
        distanceLabel.font = UIFont.getMainFont(18)
        distanceLabel.textColor = UIColor.primaryBlackColor()
        distanceLabel.textAlignment = NSTextAlignment.Center
        self.view.addSubview(distanceLabel)
        distanceLabel.snp_makeConstraints { (make) in
            make.left.equalTo(self.view).offset(10)
            make.top.equalTo(priceSegmentedControl.snp_bottom).offset(12)
            make.right.equalTo(self.view).offset(-10)
        }
        
        distanceSegmentedControl = UISegmentedControl()
        distanceSegmentedControl.tintColor = UIColor.primaryRedColor()
        distanceSegmentedControl.insertSegmentWithTitle("До 500 м", atIndex: 0, animated: false)
        distanceSegmentedControl.insertSegmentWithTitle("500м - 1км", atIndex: 1, animated: false)
        distanceSegmentedControl.insertSegmentWithTitle("От 1км", atIndex: 2, animated: false)
        self.view.addSubview(distanceSegmentedControl)
        distanceSegmentedControl.snp_makeConstraints { (make) in
            make.left.equalTo(self.view).offset(10)
            make.top.equalTo(distanceLabel.snp_bottom).offset(12)
        }
        */
        
        // НАЙТИ
        let findButton = UIButton()
        findButton.setTitle("Найти", forState: UIControlState.Normal)
        findButton.backgroundColor = UIColor.primaryRedColor()
        findButton.titleLabel?.font = UIFont.getMainFont(18)
        findButton.titleLabel?.textColor = UIColor.whiteColor()
        findButton.contentEdgeInsets = UIEdgeInsets(top: 10.0, left: 20.0, bottom: 10.0, right: 20.0)
        findButton.layer.cornerRadius = 4
        self.view.addSubview(findButton)
        findButton.snp_makeConstraints { (make) in
            make.left.equalTo(self.view).offset(10)
            make.top.equalTo(priceSegmentedControl.snp_bottom).offset(26)
            make.right.equalTo(self.view).offset(-10)
        }
        findButton.addTarget(self, action: #selector(self.search), forControlEvents: UIControlEvents.TouchUpInside)
        
        
    }


}
