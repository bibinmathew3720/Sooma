//
//  RequesterTableViewCell.swift
//  Sooma
//
//  Created by Ethan Hess on 2/25/17.
//  Copyright © 2017 Ethan Hess. All rights reserved.
//

import UIKit

class RequesterTableViewCell: UITableViewCell {

    @IBOutlet var requesterImageView: UIImageView!
    @IBOutlet var requesterNameLabel: UILabel!
    @IBOutlet var requesterTimeStampLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(requester: User) {
        
        self.requesterImageView.image = nil
        self.requesterImageView.layer.cornerRadius = 49
        self.requesterImageView.layer.masksToBounds = true
        
        self.requesterNameLabel.text = requester.username
        
        //add time stamp label
    }
    
    func congifureImage(urlString: String) {
        
        ImageHelper.sharedManager.returnDataFromURL(urlString) { (data) in
            
            if (data != nil) {
                
                DispatchQueue.main.async {
                    
                    self.requesterImageView.image = UIImage(data: data!)
                }
            }
        }
    }

}
