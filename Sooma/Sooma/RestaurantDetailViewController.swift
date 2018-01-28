//
//  RestaurantDetailViewController.swift
//  Sooma
//
//  Created by Ethan Hess on 3/11/17.
//  Copyright © 2017 Ethan Hess. All rights reserved.
//

import UIKit

//link to credit https://icons8.com/web-app/38867/Star-Half-Empty

class RestaurantDetailViewController: UIViewController {
    
    //var restaurant : Restaurant!
    var yelpRestaurant : YelpEstablishment!
    var waitTime : String?
    
    var urlToOpen : URL?
    
    @IBOutlet var ratingOne: UIImageView!
    @IBOutlet var ratingTwo: UIImageView!
    @IBOutlet var ratingThree: UIImageView!
    @IBOutlet var ratingFour: UIImageView!
    @IBOutlet var ratingFive: UIImageView!
    
    @IBOutlet var restaurantNameLabel: UILabel!
    @IBOutlet var restaurantImageView: UIImageView!
    
    
    @IBOutlet var waitTimeLabel: UILabel!
    @IBOutlet var urlLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
//    func setRestaurant(restaurant: Restaurant) {
//        
//        self.restaurant = restaurant
//    }
    
    func setRestaurant(yelpRestaurant: YelpEstablishment) {
        
        self.yelpRestaurant = yelpRestaurant
    }
    
    @IBAction func urlLabelTapped(_ sender: Any) {
        
        //open in internet
        
        if (self.yelpRestaurant.urlString != "") {
            
            self.urlToOpen = URL(string: self.yelpRestaurant.urlString)
            
            if UIApplication.shared.canOpenURL(self.urlToOpen!) {
            
                UIApplication.shared.open(urlToOpen!, options: [:], completionHandler: nil)
            }
        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        if (self.restaurant != nil) {
//        
//            self.configureViewsWithRestaurant()
//            
//        }
        
        if (self.yelpRestaurant != nil) {
            
            self.configureViewsWithRestaurant()
            
            print("RATING! \(self.yelpRestaurant.rating)")
            
            configureRating()
            
        }
        
    
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }
    
    func configureRating() {
        
        let rating = self.yelpRestaurant.rating as! Float
        
        if rating < 1 {
            
        }
        
        else if rating < 2 && rating > 1 {
            
            self.ratingOne.image = UIImage(named: "Star")
        }
        
        else if rating < 3 && rating > 2 {
            
            self.ratingOne.image = UIImage(named: "Star")
            self.ratingTwo.image = UIImage(named: "Star")
        }
        
        else if rating < 4 && rating > 3 {
            
            self.ratingOne.image = UIImage(named: "Star")
            self.ratingTwo.image = UIImage(named: "Star")
            self.ratingThree.image = UIImage(named: "Star")
            
        }
        
        else if rating < 5 && rating > 4 {
            
            self.ratingOne.image = UIImage(named: "Star")
            self.ratingTwo.image = UIImage(named: "Star")
            self.ratingThree.image = UIImage(named: "Star")
            self.ratingFour.image = UIImage(named: "Star")
        }
        
        else if rating == 5 {
            
            self.ratingOne.image = UIImage(named: "Star")
            self.ratingTwo.image = UIImage(named: "Star")
            self.ratingThree.image = UIImage(named: "Star")
            self.ratingFour.image = UIImage(named: "Star")
            self.ratingFive.image = UIImage(named: "Star")
        }
        
    }
    
    func configureViewsWithRestaurant() {
        
        //self.restaurantNameLabel.text = self.restaurant.name
        self.restaurantNameLabel.text = self.yelpRestaurant.name
    
        //if let imageURL = self.restaurant.imageURL {
        
        let imageURL = self.yelpRestaurant.imageURL
        
        let url = NSURL(string: imageURL)
        let data = NSData(contentsOf: url as! URL)
            
        DispatchQueue.main.async {
                
            self.restaurantImageView.image = UIImage(data: data! as Data)
            
            }
        //}
    
        //self.ratingImageView = //TODO: configure image according to wait time
        
        self.waitTimeLabel.text = self.waitTime!
    
        //self.urlLabel.text = //yelp url
        
        //getURLFromYelp()
    }
    
//    func getURLFromYelp() {
//        
//        NetworkController.sharedInstance.getYelpDataAlamofire { (yelpRestaurants) in
//            
//            if (yelpRestaurants != nil) {
//                
//                for restaurant in yelpRestaurants! {
//                    
//                    print("RESTAURANT COMPARISON \(self.restaurant.name) \(restaurant.name)")
//                    
//                    if restaurant.name == self.restaurant.name {
//                        
//                        self.urlToOpen = URL(string: restaurant.urlString)
//                    }
//                }
//            }
//        }
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
