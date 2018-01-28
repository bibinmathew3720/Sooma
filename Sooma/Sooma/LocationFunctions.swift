//
//  LocationFunctions.swift
//  Sooma
//
//  Created by Ethan Hess on 10/17/16.
//  Copyright © 2016 Ethan Hess. All rights reserved.
//

import UIKit
import CoreLocation

class LocationFunctions: NSObject {
    
    static let sharedInstance = LocationFunctions()
    
    var locationManager = CLLocationManager()
    var currentLocation: CLLocationCoordinate2D?
    
    var locationReturnedBlock: ((_ currentLocation: CLLocationCoordinate2D)->Void)?
    var sentALocation = true
    
    //initialization
    
    override init() {
        super.init()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
    }
    
    func locationWithComplete(_ locationComplete:@escaping (_ currentLocation: CLLocationCoordinate2D)->Void) {

        self.sentALocation = false
        self.locationReturnedBlock = locationComplete
        self.locationManager.startUpdatingLocation()
    }
}

extension LocationFunctions: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let  mostRecentLocation = locations.last {
            if let currentLocation : CLLocationCoordinate2D = CLLocationCoordinate2DMake(mostRecentLocation.coordinate.latitude, mostRecentLocation.coordinate.longitude) {
                self.currentLocation = currentLocation
                
                if self.sentALocation == false {
                    self.sentALocation = true
                    
                    // Only call completion handler if it exists
                    
                    if let complete = self.locationReturnedBlock {
                        complete(currentLocation)
                    }
                    else {
 
                    }
                    // Set completion handler to nil so that it cannot be call again
                    self.locationReturnedBlock = nil
                }
                self.locationManager.stopUpdatingLocation()
                
            }
        }
    }
}
