//
//  Restaurant.swift
//  Sooma
//
//  Created by Ethan Hess on 10/17/16.
//  Copyright © 2016 Ethan Hess. All rights reserved.
//

import UIKit

class Restaurant {
    
    //keys 
    
    let kCuisinesKey = "cuisines"
    let kImageUrlKey = "featured_image"
    let kOnlineDeliveryKey = "has_online_delivery"
    let kLocationKey = "location"
    
    //these two are wrapped in location dictionary
    
    let kAddressKey = "address"
    let kCityKey = "city"
    
    let kNameKey = "name"
    let kUserRatingWrapperDictKey = "user_rating"
    let kRatingKey = "rating_text"
    let kNumericalRating = "aggregate_rating"
    let kAverageCostKey = "average_cost_for_two"
    
    var name : String
    var averageCostForTwo : Int
    var cuisines : String
    var imageURL : String?
    var hasOnlineDelivery : Bool
    var address : String
    var city : String
    var rating : String
    var numericalRating : String

    
    init(_ dictionary: Dictionary<String, Any>) {
        
        if dictionary[kNameKey] as? String != nil {
           self.name = dictionary[kNameKey] as! String
        }
        else {
            self.name = "No name"
        }
        
        if dictionary[kAverageCostKey] as? Int != nil {
            self.averageCostForTwo = dictionary[kAverageCostKey] as! Int
        }
        else {
            self.averageCostForTwo = 0
        }
    
        if ((dictionary[kLocationKey] as? [String: Any])?[kAddressKey] as? String) != nil {
            self.address = ((dictionary[kLocationKey] as! [String: Any])[kAddressKey] as! String)
        }
        else {
            self.address = ""
        }
        
        if dictionary[kCuisinesKey] as? String != nil {
            self.cuisines = dictionary[kCuisinesKey] as! String
        }
        else {
            self.cuisines = ""
        }
        
        if (dictionary[kLocationKey] as? [String: Any])?[kCityKey] as? String != nil {
            self.city = (dictionary[kLocationKey] as! [String: Any])[kCityKey] as! String
        }
        else {
            self.city = ""
        }
        
        if dictionary[kOnlineDeliveryKey] as? Bool != nil {
            self.hasOnlineDelivery = dictionary[kOnlineDeliveryKey] as! Bool
        }
        else {
            self.hasOnlineDelivery = false
        }
        if dictionary[kNumericalRating] as? String != nil {
            self.rating = (dictionary[kUserRatingWrapperDictKey] as! [String: Any])[kRatingKey] as! String
        }
        else {
            self.rating = ""
        }
        
        if dictionary[kNumericalRating] as? String != nil {
            self.numericalRating = dictionary[kNumericalRating] as! String
        }
        else {
            self.numericalRating = ""
        }
        
        if dictionary[kImageUrlKey] as? String != nil {
            self.imageURL = dictionary[kImageUrlKey] as? String
        }
        else {
            self.imageURL = ""
        }
    }
}
