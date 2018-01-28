//
//  MainRestaurantRequestTableViewController.swift
//  Sooma
//
//  Created by Ethan Hess on 2/18/17.
//  Copyright © 2017 Ethan Hess. All rights reserved.
//

import UIKit

class MainRestaurantRequestTableViewController: UIViewController {
    
    var requesters : [User] = []
    
    var currentRestaurantUser : RestaurantUser?

    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        queryForRequesters()
    }
    
    func refresh() {
        
        DispatchQueue.main.async {
            
            self.tableView.reloadData()
        }
    }
    
    func queryForRequesters() {
        
        if let currentUID = FIRAuth.auth()?.currentUser?.uid {
            
            DataService.sharedManager.queryForCurrentRestaurantUsers(complete: { (restaurantUserArray) in
                
                for restUser in restaurantUserArray! {
                    
                    if restUser.uid == currentUID {
                        
                        self.currentRestaurantUser = restUser
                        
                        self.title = restUser.restaurantName
                        
                        self.getRequesters()
                    }
                    
                }
            })
        }
    }
    
    func getRequesters() {
        
        var tempArray : [User] = []
        
        DataService.sharedManager.reference.child("Requests").child(self.currentRestaurantUser!.restaurantName!).child("requesters").observe(.value, with: { (snappy) in
            
            if (snappy.exists()) {
                
                if let snapArray = snappy.children.allObjects as? [FIRDataSnapshot] {
                    
                    //sync our uid array with all of the users and create our requesters array
                    
                    DataService.sharedManager.queryForUsers(complete: { (users) in
                        
                        if (users != nil) {
                            
                            for theUser in users! {
                                
                                var userIDString : String?
                                
                                for dataSnapShot in snapArray {
                                    
                                    userIDString = dataSnapShot.value as? String
                                
                                
                                if theUser.uid == userIDString {
                                    
                                    theUser.snapKey = dataSnapShot.key
                                    
                                    tempArray.append(theUser)
                                    self.requesters = tempArray
                                    
                                }
                                    
                                }
                            }
                        }
                        
                        self.refresh()
                    })
                }
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logOutTapped(_ sender: Any) {
        
        do {
        
            try! FIRAuth.auth()?.signOut()
            logOutCompletion()
        }
        catch {
            
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    func logOutCompletion() {
        
        let storyBoard = self.storyboard
        
        let mainVC = storyBoard?.instantiateViewController(withIdentifier: "mainVC")
        
        self.present(mainVC!, animated: true, completion: nil)
    }
}

extension MainRestaurantRequestTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! RequesterTableViewCell
        
        let requester = self.requesters[indexPath.row]
        
        cell.configure(requester: requester)
        
        if (requester.profilePicDownloadURL != nil && requester.profilePicDownloadURL != "") {
            
            DispatchQueue.main.async {
                
                cell.congifureImage(urlString: requester.profilePicDownloadURL!)
            }
        }
        
        //evenually add picture
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return requesters.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        //eventually delete here
        
        let alertController = UIAlertController(title: "Options", message: "", preferredStyle: .alert)
        
        let alertActionOne = UIAlertAction(title: "Notify User", style: .default) { (action) in
            
            //Send user a message here
        }
        
        let alertActionTwo = UIAlertAction(title: "Delete User", style: .default) { (action) in
            
            //Delete action here
        }
        
        let alertActionThree = UIAlertAction(title: "Nevermind", style: .cancel, handler: nil)
        
        alertController.addAction(alertActionOne)
        alertController.addAction(alertActionTwo)
        alertController.addAction(alertActionThree)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == UITableViewCellEditingStyle.delete {
            
            tableView.beginUpdates()
            
            let requester = self.requesters[indexPath.row]
            
            requesters.remove(at: indexPath.row)
            
        DataService.sharedManager.reference.child("Requests").child(self.currentRestaurantUser!.restaurantName!).child("requesters").child(requester.snapKey!).removeValue()
            
            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
            tableView.endUpdates()
        }
    }
}
