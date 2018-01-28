//
//  UserDetailViewController.swift
//  Sooma
//
//  Created by Ethan Hess on 9/19/17.
//  Copyright © 2017 Ethan Hess. All rights reserved.
//

import UIKit

class UserDetailViewController: UIViewController {

    @IBOutlet var profilePictureImageVIew: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    
    var profileUser : User!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setUpViews()
        
        self.profilePictureImageVIew.layer.cornerRadius = 10
        self.profilePictureImageVIew.layer.borderColor = UIColor.black.cgColor
        self.profilePictureImageVIew.layer.borderWidth = 1
        self.profilePictureImageVIew.layer.masksToBounds = true
    }
    
    func setUpViews() {
        
        print("USER \(profileUser.username)")
        
        self.nameLabel.text = profileUser.username
        
        self.title = profileUser.username
        
        ImageHelper.sharedManager.returnDataFromURL(profileUser.profilePicDownloadURL!) { (data) in
            
            if ((data) != nil) {
                self.profilePictureImageVIew.image = UIImage(data: data!)
            } else {
                print("No data")
            }
        }
    }

    @IBAction func dismissTapped(_ sender: Any) {
       // self.dismiss(animated: true, completion: nil)
        
        self.performSegue(withIdentifier: "unwindSegueToVC1", sender: nil)
    }

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
