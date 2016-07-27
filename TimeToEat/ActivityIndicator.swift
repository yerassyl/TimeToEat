//
//  ActivityIndicator.swift
//  TimeToEat
//
//  Created by User on 15.07.16.
//  Copyright © 2016 yerassyl. All rights reserved.
//

import Foundation

extension UIViewController {
    
     func displayNavBarActivity() {
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: .White)
        indicator.startAnimating()
        let item = UIBarButtonItem(customView: indicator)
        
        self.navigationItem.leftBarButtonItem = item
        
    }
    
     func dismissNavBarActivity() {
        self.navigationItem.leftBarButtonItem = nil
    }
    
}