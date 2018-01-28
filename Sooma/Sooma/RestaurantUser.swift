//
//  RestaurantUser.swift
//  Sooma
//
//  Created by Ethan Hess on 2/18/17.
//  Copyright © 2017 Ethan Hess. All rights reserved.
//

import UIKit

class RestaurantUser {
    
    var restaurantName : String?
    var restaurantEmail : String?
    var restaurantProfilePic : String?
    var restaurantPhone : String?
    var key : String?
    var uid : String?
    
    init(restaurantName: String?, restaurantEmail: String?, restaurantProfilePic: String?, restaurantPhone: String?, key: String?, uid: String?) {
        
        self.restaurantName = restaurantName
        self.restaurantEmail = restaurantEmail
        self.restaurantProfilePic = restaurantProfilePic
        self.restaurantPhone = restaurantPhone
        self.key = key
        self.uid = uid
    }

}
