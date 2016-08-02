//
//  SearchViewController.swift
//  TimeToEat
//
//  Created by User on 26.07.16.
//  Copyright © 2016 yerassyl. All rights reserved.
//

import UIKit
import TTRangeSlider
import DLRadioButton

class SearchViewController: UIViewController, UITextFieldDelegate {
    // get singleton model class to work with logic
    let placesModelLogic = PlacesLogic.PlacesLogicSingleton
    
    let lowerRange = 500.0
    let upperRange = 1000.0
    let priceUpperRangeMax: Float = 3000.0
    var priceSlider = TTRangeSlider()
    var nameTextField = UITextField()
    var priceLowerRange: UILabel!
    var priceUpperRange: UILabel!
    
    var sortByLabel = UILabel()
    var byDistanceRadio: DLRadioButton!
    var byPriceRadio: DLRadioButton!
    
    var findButton = UIButton()

    var sortingType: SortingType!
    
    var placesTableViewDelegate: PlacesTableViewProtocol?
    var pinsDelegate: MapPinsProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        // set navigation bar title
        self.navigationItem.titleView = UIImageView(image: UIImage(named: "logo_block"))
        self.navigationItem.titleView?.tintColor = UIColor.whiteColor()
        
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(title: "Отмена", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(self.pop))]
        
        self.sortingType = SortingType.byDistance
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
            self.findButton.enabled = true
            self.findButton.alpha = 1.0
            // sort here if sortingType == .byPrice
            if self.sortingType == SortingType.byPrice {
                self.placesModelLogic.sortBy(self.sortingType)
            }
            // if view controller that initiated search is MainViewController
            if self.placesTableViewDelegate != nil {
                self.placesTableViewDelegate!.reloadPlacesTableView(self.sortingType, searched: true)
            }
            if self.pinsDelegate != nil {
               self.pinsDelegate?.reloadPins()
            }
            self.navigationController?.popViewControllerAnimated(false)
        }
        
    }
    
    // MARK: - DLRadioButton
    
    private func createRadioButton(frame : CGRect, title : String, color : UIColor) -> DLRadioButton {
        let radioButton = DLRadioButton(frame: frame);
        radioButton.titleLabel!.font = UIFont.getMainFont(18)
        radioButton.setTitle(title, forState: UIControlState.Normal);
        radioButton.setTitleColor(color, forState: UIControlState.Normal);
        radioButton.iconColor = color;
        radioButton.indicatorColor = color;
        //radioButton.iconOnRight = true
        radioButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left;
        radioButton.addTarget(self, action: #selector(self.selectSortingType), forControlEvents: UIControlEvents.TouchUpInside);
        self.view.addSubview(radioButton);
        
        return radioButton;
    }
    
    func selectSortingType(radioButton : DLRadioButton){
        if radioButton.selectedButton()!.titleLabel!.text! == "Расстоянию" {
            sortingType = SortingType.byDistance
        }else {
            sortingType = SortingType.byPrice
        }
    }
    
    // MARK: - UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: UI
    
    func setup() {
        
        // По названию
        let nameLabel = UILabel()
        nameLabel.text = "По названию"
        nameLabel.font = UIFont.getMainFont(18)
        nameLabel.textColor = UIColor.primaryDarkerRedColor()
        self.view.addSubview(nameLabel)
        nameLabel.snp_makeConstraints { (make) in
            make.left.equalTo(self.view).offset(20)
            make.top.equalTo(self.view).offset(navbarHeight+12)
        }
        
        
        nameTextField.attributedPlaceholder = NSAttributedString(string: "Введите название...", attributes: [NSFontAttributeName: UIFont.getMainFont(18)])
        nameTextField.returnKeyType = UIReturnKeyType.Done
        nameTextField.delegate = self
        self.view.addSubview(nameTextField)
        nameTextField.snp_makeConstraints { (make) in
            make.left.equalTo(self.view).offset(20)
            make.top.equalTo(nameLabel.snp_bottom).offset(12)
        }
        
        // По Категориям
        let categoriesLabel = UILabel()
        categoriesLabel.text = "По категориям"
        categoriesLabel.font = UIFont.getMainFont(18)
        categoriesLabel.textColor = UIColor.primaryDarkerRedColor()
        self.view.addSubview(categoriesLabel)
        categoriesLabel.snp_makeConstraints { (make) in
            make.left.equalTo(self.view).offset(20)
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
            make.left.equalTo(self.view).offset(20)
            make.top.equalTo(categoriesLabel.snp_bottom).offset(12)
            make.right.equalTo(self.view).offset(-20)
        }
        
        // Price Range slider
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
        
        sortByLabel.text = "Сортировка по"
        sortByLabel.font = UIFont.getMainFont(18)
        sortByLabel.textColor = UIColor.primaryBlackColor()
        sortByLabel.textAlignment = .Center
        self.view.addSubview(sortByLabel)
        sortByLabel.snp_makeConstraints { (make) in
            make.left.equalTo(self.view).offset(10)
            make.top.equalTo(priceSlider.snp_bottom).offset(12)
            make.right.equalTo(self.view).offset(-10)
        }
        
        byDistanceRadio = createRadioButton(CGRectMake(0, 0, 362, 44),
                                            title: "Расстоянию", color: UIColor.primaryRedColor())
        byPriceRadio = createRadioButton(CGRectMake(0, 0, 362, 44),
                                         title: "Цене", color: UIColor.primaryRedColor())
        
        byDistanceRadio.otherButtons = [byPriceRadio]
        
        byDistanceRadio.snp_makeConstraints { (make) in
            make.left.equalTo(self.view).offset(20)
            make.top.equalTo(sortByLabel.snp_bottom).offset(8)
            make.right.equalTo(self.view).offset(-20)
        }

        byPriceRadio.snp_makeConstraints { (make) in
            make.left.equalTo(self.view).offset(20)
            make.top.equalTo(byDistanceRadio.snp_bottom).offset(16)
            make.right.equalTo(self.view).offset(-20)
        }
        
        // НАЙТИ
        
        findButton.setTitle("Найти", forState: UIControlState.Normal)
        findButton.backgroundColor = UIColor.primaryRedColor()
        findButton.titleLabel?.font = UIFont.getMainFont(18)
        findButton.titleLabel?.textColor = UIColor.whiteColor()
        findButton.contentEdgeInsets = UIEdgeInsets(top: 10.0, left: 20.0, bottom: 10.0, right: 20.0)
        findButton.layer.cornerRadius = 4
        self.view.addSubview(findButton)
        findButton.snp_makeConstraints { (make) in
            make.left.equalTo(self.view).offset(28)
            make.top.equalTo(byPriceRadio.snp_bottom).offset(26)
            make.right.equalTo(self.view).offset(-28)
        }
        findButton.addTarget(self, action: #selector(self.search), forControlEvents: UIControlEvents.TouchUpInside)
        
        
    }


}
