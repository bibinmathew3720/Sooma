//
//  WaitTime.swift
//  Sooma
//
//  Created by Ethan Hess on 3/4/17.
//  Copyright © 2017 Ethan Hess. All rights reserved.
//

import UIKit

class WaitTime: NSObject {
    
    var restaurantName : String
    var timeArray : [Int]

    init(restaurantName: String!, timeArray: [Int]) {
        
        self.restaurantName = restaurantName
        self.timeArray = timeArray
    }
}
