
//  ViewController.swift
//  Sooma
//
//  Created by Ethan Hess on 9/3/16.
//  Copyright © 2016 Ethan Hess. All rights reserved.


import UIKit
//import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

let enterAppSegue = "enterApp"
let enterAppToRestaurantsSegue = "toRestaurants"

let restLoginSegue = "restLogin"

class ViewController: UIViewController {

    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if FIRAuth.auth()?.currentUser != nil {
            
            DataService.sharedManager.queryForUsers(complete: { (userArray) in
                
                if (userArray != nil) {
                    
                    for theUser in userArray! {
                        
                        if theUser.uid == FIRAuth.auth()!.currentUser!.uid {
                            
                            self.performSegue(withIdentifier: enterAppSegue, sender: nil)
                        }
                    }
                }
            })
            
            DataService.sharedManager.queryForCurrentRestaurantUsers(complete: { (restaurantUserArray) in
                
                if (restaurantUserArray != nil) {
                    
                    for restUser in restaurantUserArray! {
                        
                        if restUser.uid == FIRAuth.auth()!.currentUser!.uid {
                            
                            self.performSegue(withIdentifier: enterAppToRestaurantsSegue, sender: nil)
                        }
                    }
                }
            })
        }
    }

    @IBAction func loginTapped(_ sender: AnyObject) {
        
        let email = emailTextField.text
        let password = passwordTextField.text
        
        if email != "" && password != "" {
            
            FIRAuth.auth()?.signIn(withEmail: email!, password: password!, completion: { (user, error) in
                
                if error != nil {
                    self.popAlert(error!.localizedDescription, message: "")
                }
                    
                else {
                    
                    DataService.sharedManager.queryForUsers(complete: { (userArray) in
                        
                        if (userArray != nil) {
                            
                            for theUser in userArray! {
                                
                                if theUser.uid == user!.uid {
                                    
                                    self.performSegue(withIdentifier: enterAppSegue, sender: nil)
                                }
                            }
                        }
                    })
                    
                    DataService.sharedManager.queryForCurrentRestaurantUsers(complete: { (restaurantUsers) in
                        
                        if (restaurantUsers != nil) {
                            
                            for theUser in restaurantUsers! {
                                
                                if theUser.uid == user!.uid {
                                    
                                    self.performSegue(withIdentifier: enterAppToRestaurantsSegue, sender: nil)
                                }
                            }
                        }
                    })
                }
            })
        }
            
        else {
            
            popAlert("Please enter a valid email and password", message: "")
        }
    }
    
    @IBAction func signUpTapped(_ sender: AnyObject) {
        
        let email = emailTextField.text
        let password = passwordTextField.text
        
        if email != "" && password != "" {
            
            FIRAuth.auth()?.createUser(withEmail: email!, password: password!, completion: { (user, error) in
                
                if error != nil {
                    self.popAlert(error!.localizedDescription, message: "")
                }
                    
                else {
                    
                    let userDict = [kUidKey: user?.uid, kEmailKey: email, kBioKey: "", kProfilePicURLKey: "", kUsernameKey: "Your username", kPointsKey: "0"]
                    
                    self.sendUserToFirebase(dictionary: userDict)
                    
                    self.performSegue(withIdentifier: enterAppSegue, sender: nil)
                }
            })
        }
        else {
            
            popAlert("Please enter a valid email and password", message: "")
        }
    }
    
    func sendUserToFirebase(dictionary: Dictionary<String, Any>) {
        
        DataService.sharedManager.reference.child("Users").childByAutoId().setValue(dictionary)
    }
    
    
    @IBAction func toRestaurantTapped(_ sender: Any) {
        
        self.performSegue(withIdentifier: restLoginSegue, sender: nil)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
    }
    
    func popAlert(_ title: String, message: String) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okayAction = UIAlertAction(title: "Okay!", style: .cancel, handler: nil)
        alertController.addAction(okayAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
}
