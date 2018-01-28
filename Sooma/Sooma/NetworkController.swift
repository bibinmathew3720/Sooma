//
//  NetworkController.swift
//  Sooma
//
//  Created by Ethan Hess on 10/17/16.
//  Copyright © 2016 Ethan Hess. All rights reserved.
//

import UIKit
import Alamofire

class NetworkController: NSObject {

    static let sharedInstance = NetworkController()
    
    func grabRestaurantData(_ url: URL, completion:@escaping (_ resultData: Data?) -> Void) {
        
        let sessionConfig = URLSessionConfiguration.default
        
        let headerDict = ["Accept" :"application/json",
        "user-key" : "\(ZOMATO_API_KEY)"]
        
        sessionConfig.httpAdditionalHeaders = headerDict
        
        let urlSession = URLSession(configuration: sessionConfig)
        
        let dataTask = urlSession.dataTask(with: url, completionHandler: { (data, response, error) in
            
            guard let dataReturned = data else { print("NO DATA: \(error?.localizedDescription)"); completion(nil); return }
            
            completion(dataReturned)
            
            print("DATA: \(dataReturned)")
        }) 
        
        dataTask.resume()
        
    }
    
    func accessTokenExists() -> Bool {
        
        return UserDefaults.standard.object(forKey: "tokenKey") != nil
    }
    
    func accessToken() -> String {
        
        return UserDefaults.standard.object(forKey: "tokenKey") as! String
    }
    
    func authYelp() {
        
        let authURLString = "https://api.yelp.com/oauth2/token"
        
        let url = URL(string: authURLString)
        
        let parameters = [
            "client_id": v3AppID,
            "client_secret": v3AppSecret,
            "grant_type": "client_credentials"
        ]
        
        let headerDict = ["Content-Type": "application/x-www-form-urlencoded"]
        
        Alamofire.request(url!, method: .post, parameters: parameters, headers: headerDict).responseJSON { (data) in
            
            print("DATA \(data.result.value)")
            
            let dataDict = data.result.value as! Dictionary<String, Any>
                
            if let accessToken = dataDict["access_token"] as? String {
                
                UserDefaults.standard.set(accessToken, forKey: "tokenKey")
            }
            
        }
    }
    
    func getYelpDataAlamofire(completion:@escaping (_ establishmentArray: [YelpEstablishment]?) -> Void) {
        
        if accessTokenExists() {
            
            LocationFunctions.sharedInstance.locationWithComplete({ (location) in
                
                let urlString = URL(string: "https://api.yelp.com/v3/businesses/search")
                
                let headerDict = ["Authorization":"Bearer \(self.accessToken())"]

                let parameters = ["latitude": location.latitude, "longitude": location.longitude, "term":"food"] as [String : Any]
                
                Alamofire.request(urlString!, method: .get, parameters: parameters, headers: headerDict).responseJSON { (data) in
                    
                    let dataDict = data.result.value as! Dictionary<String, Any>
                    
                    print("Data dict \(dataDict)")
                    
                    if let businessArray = dataDict["businesses"] as? [Any] {
                        
                        var restaurants: [YelpEstablishment] = []
                        
                        for business in businessArray {
                                
                            if let business = business as? [String: Any] {
                                
                            let restaurant = YelpEstablishment(json: business)
                                
                            if restaurant != nil {
                            
                                restaurants.append(restaurant!)
                                    
                                }
                            }
                        }
                        
                        print("RESTAURANT ARRAY \(restaurants)")
                        
                        completion(restaurants)
                        
                    }
                    
                    else {
                        print("Error serializing")
                        completion(nil)
                    }
                }
            })
            
            
        }
        
        else {
            
            //need to refresh
            
            self.authYelp() //maybe add completion?
            
        }
    }
    
    
    func getYelpData() {
        
        if accessTokenExists() {
            
            //let url = URL(string: "https://api.yelp.com/v3/businesses/search")
            
            let url = URL(string: "https://api.yelp.com/v3/businesses/search?term=yoga&latitude=34.0624290&longitude=-118.3743490")
            
            var urlRequest = URLRequest(url: url!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 20.0)
            
            urlRequest.httpMethod = "GET"
            
//            urlRequest.addValue("food", forHTTPHeaderField: "term")
//            
//            urlRequest.addValue("37.785771", forHTTPHeaderField: "latitude")
//            urlRequest.addValue("-122.406165", forHTTPHeaderField: "longitude")
//            
            //add body
            
            let bodyDict = ["latitude":37.785771, "longitude":-122.406165, "term": "food"] as [String : Any]
            
            //let bodyDict = ["location":"37.788022,-122.399797", "term": "food"] as [String : Any]
            
            let bodyData = try! JSONSerialization.data(withJSONObject: bodyDict, options: .prettyPrinted)
            
            urlRequest.addValue("hmac-sha1", forHTTPHeaderField: "oauth_signature_method")
            
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.addValue("Bearer \(self.accessToken())", forHTTPHeaderField: "Authorization")
            
            //urlRequest.httpBody = bodyData
            
            let urlSession = URLSession(configuration: URLSessionConfiguration.default)
            
            let dataTask = urlSession.dataTask(with: urlRequest) { (data, response, error) in
                
                if error != nil {
                    print("error: \(error!.localizedDescription)")
                }
                
                print("DATA: \(data) RESPONSE \(response)")
                
                if data != nil {
                    
                    let resultData = self.dataToJSON(data!)
                    
                    print("Result Data: \(resultData)")
                    
                }
            }
            
            dataTask.resume()
        }
        
    }
    
    func dataToJSON(_ data: Data) -> Any? {
        
        do {
            return try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
        } catch let myJSONError {
            
            print("ERROR \(myJSONError)")
        }
        return nil
    }
}
