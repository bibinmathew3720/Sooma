//
//  DataService.swift
//  Sooma
//
//  Created by Ethan Hess on 9/19/16.
//  Copyright © 2016 Ethan Hess. All rights reserved.
//

import UIKit
//import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class DataService: NSObject {
    
    static let sharedManager = DataService()
    
    var reference : FIRDatabaseReference! //reference for data (strings etc.)
    //var refHandle : FIRDatabaseHandle!
    var storageReference : FIRStorageReference!
    
    override init() {
        super.init()
        
        reference = FIRDatabase.database().reference()
        storageReference = FIRStorage.storage().reference(forURL: STORAGE_BUCKET_URL)
        
    }
    
    func queryForUsers(complete:@escaping (_ userArray: [User]?)->Void) {
        
        var tempArray : [User] = []
        
        self.reference.child("Users").observe(.value, with: { (snapshot) in
            
            if (snapshot.exists()) {
 
                for userSubDict in snapshot.children.allObjects as! [FIRDataSnapshot] {
                    
                    let userDict = userSubDict.value as! Dictionary<String, Any>
                    
                    print("USER DICT: \(userDict)")
                    
                    let user = User(username: userDict[kUsernameKey] as? String, email: userDict[kEmailKey] as? String, profilePicDownloadURL: userDict[kProfilePicURLKey] as? String, bio: userDict[kBioKey] as? String, points: userDict[kPointsKey] as? String, key: userSubDict.key, uid: userDict[kUidKey] as? String)
                    
                    tempArray.append(user)
                }
                
                complete(tempArray)
            }
        })
    }
    
    func queryForCurrentRestaurantUsers(complete:@escaping (_ restaurants: [RestaurantUser]?)->Void) {
        
        var tempArray : [RestaurantUser] = []
        
        self.reference.child("RestaurantUsers").observe(.value, with: { (snappy) in
            
            if (snappy.exists()) {
                
                for userSubDict in snappy.children.allObjects as! [FIRDataSnapshot] {
                    
                    let userDict = userSubDict.value as! Dictionary<String, Any>
                    
                    print("USER DICT: \(userDict)")
                    
                    let restUser = RestaurantUser(restaurantName: userDict["restaurantName"] as! String?, restaurantEmail: userDict["restuarantEmail"] as! String?, restaurantProfilePic: userDict[""] as! String?, restaurantPhone: userDict["restaurantPhone"] as! String?, key: userSubDict.key, uid: userDict["restaurantUID"] as! String?)
                    
                    tempArray.append(restUser)
                }
                
                complete(tempArray)
            }
        })
    }
}
