//
//  PeopleTableViewCell.swift
//  Sooma
//
//  Created by Ethan Hess on 9/17/16.
//  Copyright © 2016 Ethan Hess. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseDatabase

class PeopleTableViewCell: UITableViewCell {

    @IBOutlet var peopleImageView: UIImageView!
    @IBOutlet var peopleNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.peopleImageView.image = nil
    }
    
    func getData(user: User) {
        
        ImageHelper.sharedManager.returnDataFromURL(user.profilePicDownloadURL!) { (data) in
            
            let imageFromData = UIImage(data: data!)
            
            DispatchQueue.main.async(execute: {
                
                //self.peopleImageView.image = nil
                self.peopleImageView.image = imageFromData
            })
        }
        
    }
}
