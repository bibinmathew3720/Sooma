//
//  ImageHelper.swift
//  Sooma
//
//  Created by Ethan Hess on 2/24/17.
//  Copyright © 2017 Ethan Hess. All rights reserved.
//

import UIKit

class ImageHelper: NSObject {
    
    static let sharedManager = ImageHelper()
    
    func returnDataFromURL(_ urlString: String, completion:@escaping(_ imageData: Data?) -> Void) {
        
        if urlString != "" {
        
        let storage = FIRStorage.storage()
        let theReference = storage.reference(forURL: urlString)
        
        theReference.data(withMaxSize: 2 * 1024 * 1024) { (data, error) in
            
            if error != nil {
                print(error!.localizedDescription)
            }
            
            else {
                
                completion(data!)
            }
        }
        }
    }
}
