//
//  InteractionGestureRecognizer.swift
//  TimeToEat
//
//  Created by User on 28.07.16.
//  Copyright © 2016 yerassyl. All rights reserved.
//

import UIKit.UIGestureRecognizerSubclass

protocol InteractionGestureRecognizerDelegate {
    func interactionDidHappen()
}


class InteractionGestureRecognizer: UIGestureRecognizer {
    
    var myDelegate: InteractionGestureRecognizerDelegate?
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent) {
        // trigger action
        self.myDelegate?.interactionDidHappen()
    }
    
}