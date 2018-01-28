//
//  PeopleViewController.swift
//  Sooma
//
//  Created by Ethan Hess on 9/17/16.
//  Copyright © 2016 Ethan Hess. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseDatabase

typealias CompletionHandler = (_ url: URL) -> Void

class PeopleViewController: UIViewController {

    var users : [User] = []
    var userToPass : User?

    @IBOutlet var peopleTableView: UITableView!
    
    var refHandle : FIRDatabaseHandle!

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //necessary?
        
        DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
        
            self.getFirebaseData()
        }
    }
    
    func getFirebaseData() {
        
        DataService.sharedManager.queryForUsers { (users) in
            
            if (users != nil) {
                
                self.users = users!
                
                self.refresh()
            }
        }
    }
    
    func refresh() {
        
        DispatchQueue.main.async {
            
            self.peopleTableView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension PeopleViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "peopleCell") as! PeopleTableViewCell
        
        let user = users[indexPath.row]
        
        cell.peopleImageView.image = nil
        
        cell.peopleNameLabel.text = user.username
        
        cell.peopleImageView.layer.cornerRadius = 3
        cell.peopleImageView.layer.borderColor = UIColor.gray.cgColor
        cell.peopleImageView.layer.borderWidth = 2
        cell.peopleImageView.layer.masksToBounds = true
        
        if user.profilePicDownloadURL != nil && user.profilePicDownloadURL != "" {
            
            cell.getData(user: user)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        //Things to add: Add friend and see their profile perhaps? 
        
        let user = users[indexPath.row]
        
        self.userToPass = user
        self.performSegue(withIdentifier: "toUserDetail", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toUserDetail" {
            
            if userToPass != nil {
                
                let destination = segue.destination as! UserDetailViewController
                
                destination.profileUser = userToPass
            }
        }
    }
    
    @IBAction func unwindToVC1(segue: UIStoryboardSegue) {
    
    }
    
//    override func unwind(for unwindSegue: UIStoryboardSegue, towardsViewController subsequentVC: UIViewController) {
//        
//        
//    }
    
}
