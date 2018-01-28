
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
import LocalAuthentication

let enterAppSegue = "enterApp"
let enterAppToRestaurantsSegue = "toRestaurants"

let restLoginSegue = "restLogin"

class ViewController: UIViewController {

    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       let userName = UserDefaults.standard.value(forKey: kEmailUDKey)
        if(userName==nil){
          
        }
        else{
            let isEnabledFaceId  = UserDefaults.standard.bool(forKey: kEnableFaceIDKey)
            if(isEnabledFaceId == true){
                self.authenticateUser()
            }
        }
    }
    
    func authenticateUser() {
        let authenticationContext = LAContext()
        var error:NSError?
        
        
        guard authenticationContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            print("No Sensor")
            return
        }
        
        authenticationContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "eRemit Login with Biometric ID", reply: {
            (success, error) -> Void in
            DispatchQueue.main.async {
                if( success ) {
                    let email = UserDefaults.standard.value(forKey: kEmailUDKey)
                    let password = UserDefaults.standard.value(forKey: kPasswordUDKey)
                    self.callingFirebaseLogInWithEmail(email: email as! String, password: password as! String)
                    print("Success")
                    // Fingerprint recognized
                    // self.isFromPassCode = true
                    //self.performSegue(withIdentifier: "home", sender: self)
                }else {
                    if let error = error {
                        print(error)
                        //                            self.numberOfAttempt += 1
                        //                            if self.numberOfAttempt == 5 {
                        //                                ER_DEFAULTS.set(true, forKey: userDefaultsKey.isFirstTime.rawValue)
                        //                                APPDELEGATE?.setLandingScreen(view: .login)
                        //                            }
                        self.popAlert("Authentication Failed", message: "Face ID authentication failed")
                    }
                }
            }
        })
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
    
    func saveToKeychainAccess(email:String,password:String){
        UserDefaults.standard.setValue(email, forKey: kEmailUDKey)
        UserDefaults.standard.setValue(password, forKey: kPasswordUDKey)
       
//        NSKeyedArchiver.setValue(emailTextField.text, forKey: "username")
//        NSKeyedArchiver.setValue(passwordTextField.text, forKey: "password")
    }

    @IBAction func loginTapped(_ sender: AnyObject) {
        self.callingFirebaseLogInWithEmail(email: emailTextField.text!, password: passwordTextField.text!)
    }
    
    func callingFirebaseLogInWithEmail(email:String,password:String){
//        let email = emailTextField.text
//        let password = passwordTextField.text
        
        if email != "" && password != "" {
            
            FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
                
                if error != nil {
                    self.popAlert(error!.localizedDescription, message: "")
                }
                    
                else {
                    
                    DataService.sharedManager.queryForUsers(complete: { (userArray) in
                        
                        if (userArray != nil) {
                            
                            for theUser in userArray! {
                                
                                if theUser.uid == user!.uid {
                                    self.saveToKeychainAccess(email: email, password: password)
                                    self.performSegue(withIdentifier: enterAppSegue, sender: nil)
                                }
                            }
                        }
                    })
                    
                    DataService.sharedManager.queryForCurrentRestaurantUsers(complete: { (restaurantUsers) in
                        
                        if (restaurantUsers != nil) {
                            
                            for theUser in restaurantUsers! {
                                
                                if theUser.uid == user!.uid {
                                    self.saveToKeychainAccess(email: email, password: password)
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
