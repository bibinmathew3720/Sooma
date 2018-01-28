//
//  YelpEstablishment.swift
//  Sooma
//
//  Created by Ethan Hess on 3/16/17.
//  Copyright © 2017 Ethan Hess. All rights reserved.
//

import UIKit
import CoreLocation

class YelpEstablishment: NSObject { //To get URL to open in yelp
    
    let id : String
    let name : String
    let distance : Double // meters not feet
    let location : CLLocation
    let urlString : String
    let imageURL : String
    let rating : Any // is number, change later?
    
    init?(json: [String: Any]) {
        
        if let id = json["id"] as? String {
            self.id = id
        }
    
        else {
            self.id = ""
        }
    
        if let name = json["name"] as? String {
            self.name = name
        }
        
        else {
            self.name = ""
        }
        
        if let distance = json["distance"] as? Double {
            self.distance = distance
        }
        else {
            self.distance = 0.0
        }
        
        if let coordinatesJSON = json["coordinates"] as? [String: Double] {
            
            let latitude = coordinatesJSON["latitude"]
            let longitude = coordinatesJSON["longitude"]
            
            self.location = CLLocation(latitude: latitude!, longitude: longitude!)
        } else {
            self.location = CLLocation()
        }

        if let url = json["url"] as? String {
            self.urlString = url
        } else {
            self.urlString = ""
        }
        
        if let imageURL = json["image_url"] as? String {
            
            self.imageURL = imageURL
        } else {
            self.imageURL = ""
        }
        
        if let rating = json["rating"] {
            
            print("Rating: \(rating)")
            
            self.rating = rating
        } else {
            self.rating = ""
        }
    }

}
