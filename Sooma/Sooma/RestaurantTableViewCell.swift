//
//  RestaurantTableViewCell.swift
//  Sooma
//
//  Created by Ethan Hess on 9/3/16.
//  Copyright © 2016 Ethan Hess. All rights reserved.
//

import UIKit

protocol AddNameDelegate : class {
    
//    func addNameWithRestaurant(restaurant: Restaurant)
//    
//    func addWaitTime(restaurant: Restaurant)
//    
    func addNameWithYelpRestaurant(yelpRestaurant: YelpEstablishment)
    
    func addWaitTime(restaurant: YelpEstablishment)
}

class RestaurantTableViewCell: UITableViewCell {

    @IBOutlet var cellImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var ratingImageView: UIImageView!
    @IBOutlet var waitTimeLabel: UILabel!
    @IBOutlet var addButton: UIButton!
    @IBOutlet var addWaitButton: UIButton!
    
    //var theRestaurant : Restaurant?
    
    var yelpRestaurant : YelpEstablishment?
    
    weak var delegate : AddNameDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.cellImageView.layer.cornerRadius = 3
        self.cellImageView.layer.masksToBounds = true
        
        self.addButton.layer.cornerRadius = 3
        self.addButton.layer.masksToBounds = true
        self.addButton.layer.borderColor = UIColor.white.cgColor
        self.addButton.layer.borderWidth = 1
        
        self.addWaitButton.layer.cornerRadius = 3
        self.addWaitButton.layer.masksToBounds = true
        self.addWaitButton.layer.borderColor = UIColor.white.cgColor
        self.addWaitButton.layer.borderWidth = 1
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.waitTimeLabel.text = ""
        self.imageView?.image = nil
    }
    
//    func setRestaurant(restaurant: Restaurant) {
//        
//        self.theRestaurant = restaurant
//    }
    
    func setYelpRestaurant(yelpRestaurant: YelpEstablishment) {
        
        self.yelpRestaurant = yelpRestaurant
    }
    
    @IBAction func addNameTapped(_ sender: AnyObject) {
        
        //self.delegate?.addNameWithRestaurant(restaurant: self.theRestaurant!)
        self.delegate?.addNameWithYelpRestaurant(yelpRestaurant: self.yelpRestaurant!)
    }

    @IBAction func addWaitTapped(_ sender: Any) {
        
        //self.delegate?.addWaitTime(restaurant: self.theRestaurant!)
        self.delegate?.addWaitTime(restaurant: self.yelpRestaurant!)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setImageFromURLString(theURLstring: String?) {
        
        DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
        
        if let theString = theURLstring {
            
            let url = NSURL(string: theString)
            
            let data = NSData(contentsOf: url as! URL)
            
            DispatchQueue.main.async {
                
                self.cellImageView.image = UIImage(data: data! as Data)
            }
          }
        }
    }
 }
