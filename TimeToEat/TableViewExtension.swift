//
//  TableViewExtension.swift
//  TimeToEat
//
//  Created by User on 11.08.16.
//  Copyright © 2016 yerassyl. All rights reserved.
//

import Foundation
import Kingfisher

extension MainViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.placesModelLogic.places.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("place", forIndexPath: indexPath) as! PlaceTableViewCell
        
        let currentPlace = self.placesModelLogic.places[indexPath.row]
        
        if currentPlace.placeImage != nil {
            cell.placeImageView?.kf_setImageWithURL(NSURL(string: currentPlace.placeImage!)!, placeholderImage: UIImage(named:"placeholder"), optionsInfo: [.Transition(ImageTransition.Fade(1))] )
            
        }
        
        cell.nameLabel.text = currentPlace.name
        cell.businessLunchLabel.text = currentPlace.lunchType
        cell.businessLunchPriceLabel.text = "\(currentPlace.lunchPrice) ₸"
        
        cell.distanceToLabel.text = currentPlace.distanceToStr
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.cellHeight = 134.0
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        // calculate cell width
        //let cellWidth = tableView.frame.height/5
        return 134
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectedPlace = self.placesModelLogic.places[indexPath.row]
        mapVC.mapSelectedPlace = selectedPlace
        self.navigationController?.pushViewController(mapVC, animated: true)
    }

    
    
}