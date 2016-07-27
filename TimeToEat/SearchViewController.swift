//
//  SearchViewController.swift
//  TimeToEat
//
//  Created by User on 26.07.16.
//  Copyright © 2016 yerassyl. All rights reserved.
//

import UIKit
import TTRangeSlider

class SearchViewController: UIViewController {
    // get singleton model class to work with logic
    let placesModelLogic = PlacesLogic.PlacesLogicSingleton
    
    let lowerRange = 500.0
    let upperRange = 1000.0
    let priceUpperRangeMax: Float = 3000.0
    var priceSlider: TTRangeSlider!
    var nameTextField: UITextField!
    var priceLowerRange: UILabel!
    var priceUpperRange: UILabel!
    
    var findButton: UIButton!

    
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
        // display activity indicator and make search button disabled
        self.displayNavBarActivity()
        self.findButton.enabled = false
        self.findButton.alpha = 0.8
        
        // get form values
        let name = nameTextField.text!
        let priceFrom = Int(priceSlider.selectedMinimum)
        let priceTo = Int(priceSlider.selectedMaximum)
        
        // start search
        self.placesModelLogic.searchPlaces(name, priceFrom: priceFrom, priceTo: priceTo ) { (Void) in
            self.dismissNavBarActivity()
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
        
        // Price Range slider
        priceSlider = TTRangeSlider()
        priceSlider.minValue = 0.0
        priceSlider.maxValue = priceUpperRangeMax
        priceSlider.selectedMinimum = 500.0
        priceSlider.selectedMaximum = 1000.0
        priceSlider.tintColorBetweenHandles = UIColor.primaryDarkerRedColor()
        priceSlider.tintColor = UIColor.primaryRedColor()
        priceSlider.minDistance = 400.0
        priceSlider.enableStep = true
        priceSlider.step = 100.0
        priceSlider.lineHeight = 2.0
        self.view.addSubview(priceSlider)
        priceSlider.snp_makeConstraints { (make) in
            make.top.equalTo(priceLabel.snp_bottom).offset(4)
            make.left.equalTo(self.view).offset(12)
            make.right.equalTo(self.view).offset(-12)
        }
            
        // НАЙТИ
        findButton = UIButton()
        findButton.setTitle("Найти", forState: UIControlState.Normal)
        findButton.backgroundColor = UIColor.primaryRedColor()
        findButton.titleLabel?.font = UIFont.getMainFont(18)
        findButton.titleLabel?.textColor = UIColor.whiteColor()
        findButton.contentEdgeInsets = UIEdgeInsets(top: 10.0, left: 20.0, bottom: 10.0, right: 20.0)
        findButton.layer.cornerRadius = 4
        self.view.addSubview(findButton)
        findButton.snp_makeConstraints { (make) in
            make.left.equalTo(self.view).offset(10)
            make.top.equalTo(priceSlider.snp_bottom).offset(26)
            make.right.equalTo(self.view).offset(-10)
        }
        findButton.addTarget(self, action: #selector(self.search), forControlEvents: UIControlEvents.TouchUpInside)
        
        
    }


}
