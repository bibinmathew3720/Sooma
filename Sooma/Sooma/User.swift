//
//  User.swift
//  Sooma
//
//  Created by Ethan Hess on 9/17/16.
//  Copyright © 2016 Ethan Hess. All rights reserved.
//

import UIKit
import Foundation

class User {
    
    var username : String?
    var email : String?
    var profilePicDownloadURL : String?
    var bio : String?
    var points : String?
    var key : String?
    var uid : String?
    var snapKey : String?
    
    init(username: String!, email: String?, profilePicDownloadURL: String?, bio: String?, points: String?, key: String?, uid: String?) {
        
        self.username = username
        self.email = email
        self.profilePicDownloadURL = profilePicDownloadURL
        self.bio = bio
        self.points = points
        self.key = key
        self.uid = uid
    }
}
