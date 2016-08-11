//
//  NoCityView.swift
//  TimeToEat
//
//  Created by User on 10.08.16.
//  Copyright © 2016 yerassyl. All rights reserved.
//

import UIKit

class NoCityView: UIView, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var placesTableViewDelegate: PlacesTableViewProtocol?
    
    var noCityDetectedLabel: UILabel!
    var citiesPickerView: UIPickerView!
    var continueButton: UIButton!
    
    // hardcoded cities
    let cities = ["Выберите город","Алматы","Астана","Иссык"]
    let citiesKeys = ["NA","Almaty","Astana","Issyk"]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        citiesPickerView.delegate = self
        citiesPickerView.dataSource = self
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UIPickerViewDataSource
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return cities.count
    }
    
    // MARK: - UIPickerViewDelegate
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        print(row)
        return cities[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let cityName = citiesKeys[row]
        if cityName == "NA" {
            disableContinueButton()
        }else {
            enableContinueButton()
        }
    }
    
    // MARK: - Actions
    
    func continueButtonPressed(){
        let selectedCity = citiesKeys[citiesPickerView.selectedRowInComponent(0)] // 0's component
        guard selectedCity != "NA" else {
            return
        }
        UserCity.city.name = selectedCity
        self.placesTableViewDelegate?.loadInitialPlaces()
    }
    
    // MARK: - UI
    
    func disableContinueButton(){
        continueButton.enabled = false
        continueButton.backgroundColor = UIColor.secondaryGreyColor()
        continueButton.setTitle("Выберите город", forState: UIControlState.Normal)
    }
    
    func enableContinueButton(){
        continueButton.enabled = true
        continueButton.backgroundColor = UIColor.primaryRedColor()
        continueButton.setTitle("Продолжить", forState: UIControlState.Normal)
    }
    
    func setup(){
        noCityDetectedLabel = UILabel()
        noCityDetectedLabel.text = ":( Мы не смогли определить ваш город, выберите ваш город из списка ниже"
        noCityDetectedLabel.font = UIFont.getMainFont(18)
        noCityDetectedLabel.textColor = UIColor.primaryRedColor()
        noCityDetectedLabel.textAlignment = .Center
        noCityDetectedLabel.lineBreakMode = .ByWordWrapping
        noCityDetectedLabel.numberOfLines = 0
        self.addSubview(noCityDetectedLabel)
        noCityDetectedLabel.snp_makeConstraints { (make) in
            make.left.equalTo(self).offset(20)
            make.right.equalTo(self).offset(-20)
            make.top.equalTo(self).offset(screenHeight/3)
        }
        
        citiesPickerView = UIPickerView()
        self.addSubview(citiesPickerView)
        citiesPickerView.snp_makeConstraints { (make) in
            make.left.equalTo(self).offset(20)
            make.top.equalTo(noCityDetectedLabel.snp_bottom).offset(12)
            make.right.equalTo(self).offset(-20)
        }
        
        continueButton = UIButton()
        continueButton.titleLabel?.font = UIFont.getMainFont(18)
        continueButton.titleLabel?.textColor = UIColor.whiteColor()
        continueButton.contentEdgeInsets = UIEdgeInsets(top: 10.0, left: 20.0, bottom: 10.0, right: 20.0)
        continueButton.layer.cornerRadius = 4
        self.disableContinueButton()
        self.addSubview(continueButton)
        continueButton.addTarget(self, action: #selector(self.continueButtonPressed), forControlEvents: UIControlEvents.TouchUpInside)
        continueButton.snp_makeConstraints { (make) in
            make.left.equalTo(self).offset(20)
            make.top.equalTo(citiesPickerView.snp_bottom).offset(12)
            make.right.equalTo(self).offset(-20)
        }
        
    }
    
}