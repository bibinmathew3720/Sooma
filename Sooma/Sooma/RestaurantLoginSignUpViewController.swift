//
//  RestaurantLoginSignUpViewController.swift
//  Sooma
//
//  Created by Ethan Hess on 2/18/17.
//  Copyright © 2017 Ethan Hess. All rights reserved.
//

import UIKit

class RestaurantLoginSignUpViewController: UIViewController {
    
    let REST_ENTER_SEGUE = "restaurantEnterSegue"

    @IBOutlet var restaurantNameField: UITextField!
    @IBOutlet var restaurantEmailField: UITextField!
    @IBOutlet var restaurantPasswordField: UITextField!
    @IBOutlet var restaurantPhoneField: UITextField!
    
    @IBOutlet var loginbutton: UIButton!
    @IBOutlet var signupButton: UIButton!
    
    @IBOutlet var loginLabel: UILabel!
    @IBOutlet var signInLabel: UILabel!
    
    @IBOutlet var viewModeSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setUpViews()
    }
    
    func setUpViews() {
        
        if viewModeSwitch.isOn {
            
            animateViewsLogin()
        }
            
        else {
            
            animateViewsSignUp()
        }
    }
    
    func animateViewsLogin() {
        
        UIView.animate(withDuration: 0.5) { 
            
            self.signInLabel.textColor = UIColor.white
            self.loginLabel.textColor = UIColor.yellow
            
            self.restaurantNameField.alpha = 0
            self.restaurantPhoneField.alpha = 0
            
            self.signupButton.alpha = 0
            self.loginbutton.alpha = 1
        }
    }
    
    func animateViewsSignUp() {
        
        UIView.animate(withDuration: 0.5) {
            
            self.signInLabel.textColor = UIColor.yellow
            self.loginLabel.textColor = UIColor.white
            
            self.restaurantNameField.alpha = 1
            self.restaurantPhoneField.alpha = 1
            
            self.signupButton.alpha = 1
            self.loginbutton.alpha = 0
        }
    }

    @IBAction func switchToggled(_ sender: Any) {
        
        setUpViews()
    }
    
    @IBAction func loginTapped(_ sender: Any) {
        
        if restaurantEmailField.text != "" && restaurantPasswordField.text != "" {
        
        FIRAuth.auth()?.signIn(withEmail: restaurantEmailField.text!, password: self.restaurantPasswordField.text!, completion: { (user, error) in
            
            if error != nil {
                print("ERROR: \(error!.localizedDescription)") //eventually pop alert for error
                
                self.popAlert(title: error!.localizedDescription, message: "")
            }
            
            else {
                
                DataService.sharedManager.queryForCurrentRestaurantUsers(complete: { (restaurantUsers) in
                    
                    if (restaurantUsers != nil ) {
                        
                        for restUser in restaurantUsers! {
                            
                            if restUser.uid == user!.uid {
                        
                                self.performSegue(withIdentifier: self.REST_ENTER_SEGUE, sender: nil)
                                
                            }
                        }
                    }
                })
            }
        })
        }
        
        else {
            
            //Alert asking user to sign up with full credentials
            
            popAlert(title: "Please enter valid credentials", message: "")
        }
    }
    
    @IBAction func signUpTapped(_ sender: Any) {
        
        if self.restaurantNameField.text != "" && restaurantEmailField.text != "" && restaurantPasswordField.text != "" && restaurantPhoneField.text != "" {
            
        FIRAuth.auth()?.createUser(withEmail: self.restaurantEmailField.text!, password: self.restaurantPasswordField.text!, completion: { (user, error) in
            
            if error != nil {
                print("ERROR: \(error!.localizedDescription)")
                self.popAlert(title: error!.localizedDescription, message: "")
            }
            
            else {
                
                let restaurantUserDict = ["restaurantName": self.restaurantNameField.text!, "restaurantUID": user!.uid, "restuarantEmail": self.restaurantEmailField.text!, "restaurantPhone": self.restaurantPhoneField.text!]
                
                self.sendUserToFirebase(dictionary: restaurantUserDict)
                
                self.performSegue(withIdentifier: self.REST_ENTER_SEGUE, sender: nil)
            }
        })
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func sendUserToFirebase(dictionary: Dictionary<String, Any>) {
        
        DataService.sharedManager.reference.child("RestaurantUsers").childByAutoId().setValue(dictionary)
    }
    
    func popAlert(title: String, message: String) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let alertActionOkay = UIAlertAction(title: "Okay!", style: .cancel, handler: nil)
        
        alertController.addAction(alertActionOkay)
        self.present(alertController, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        
    }
    
    @IBAction func backTapped(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    }
    
  
}

extension RestaurantLoginSignUpViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
}
