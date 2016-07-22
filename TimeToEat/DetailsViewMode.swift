//
//  DetailsViewMode.swift
//  TimeToEat
//
//  Created by User on 21.07.16.
//  Copyright © 2016 yerassyl. All rights reserved.
//

import Foundation

enum DetailsViewMode: CGFloat {
    case FullScreen = 0.0
    case HalfScreen = 0.6
    case SemiHide = 0.8
    case Hide = 1.0       // when details view is not shown but litle icon is shown to indicate that it is there
    case Invisible = 1.1  // not visible at all
    
//    var next: DetailsViewMode {
//        return DetailsViewMode(rawValue: (self.rawValue + 1) % 5)!
//    }
    
}
