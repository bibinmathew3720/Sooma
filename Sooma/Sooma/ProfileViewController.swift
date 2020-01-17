//
//  ProfileViewController.swift
//  Sooma
//
//  Created by Ethan Hess on 9/3/16.
//  Copyright © 2016 Ethan Hess. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class ProfileViewController: UIViewController {
    
    //var refHandle : FIRDatabaseHandle!

    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var displayNameField: UITextField!
    @IBOutlet var pointsLabel: UILabel!
    @IBOutlet weak var enableSwitch: UISwitch!
    @IBOutlet weak var enableFaceIdLabel: UILabel!
    
    var currentUser : User!
    
    var chosenImage : UIImage?
    var chosenImageData : Data?
    var downloadURLString : String!
    var imagePickerController = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.settingFaceIdSwitch()
        self.profileImageView.image = UIImage(named: "user_paceholder")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
    }
    
    func settingFaceIdSwitch(){
      // self.enableSwitch.isOn = UserDefaults.standard.bool(forKey: kEnableFaceIDKey)
        
        guard let tempeEmailId = UserDefaults.standard.value(forKey: kfaceIdEnableEmailId) else {
            
            return
        }
        let emailId = UserDefaults.standard.value(forKey: kEmailUDKey) as! String
        let faceIdEnablesEmailId = UserDefaults.standard.value(forKey: kfaceIdEnableEmailId) as! String
        if(emailId != faceIdEnablesEmailId){
            self.settingFaceidEnableControlsHidden()
        }
        else{
            let isEnabledFaceId  = UserDefaults.standard.bool(forKey: kEnableFaceIDKey)
            if(isEnabledFaceId == true){
                self.enableSwitch.isOn = true
            }
        }
    }
    
    func settingFaceidEnableControlsHidden(){
        self.enableFaceIdLabel.isHidden = true;
         self.enableSwitch.isHidden = true;
    }
    
    @IBAction func logoutTapped(_ sender: Any) {
        
        do {
        
            try! FIRAuth.auth()?.signOut()
            
            let storyBoard = self.storyboard
            
            let mainVC = storyBoard?.instantiateViewController(withIdentifier: "mainVC")
            
            self.present(mainVC!, animated: true, completion: nil)
            
        } catch {
            
            
        }
    }
    
    @IBAction func faceIdSwitchAction(_ sender: Any) {
        let faceIdSwitch = sender as! UISwitch
        if(faceIdSwitch.isOn){
            let enabledEmailId = UserDefaults.standard.value(forKey: kEmailUDKey)
            UserDefaults.standard.setValue(enabledEmailId, forKey: kfaceIdEnableEmailId)
            let enabledPasswordId = UserDefaults.standard.value(forKey: kPasswordUDKey)
            UserDefaults.standard.setValue(enabledPasswordId, forKey: kfaceIdEnablePassword)
            UserDefaults.standard.set(true, forKey: kEnableFaceIDKey)
        }
        else{
            UserDefaults.standard.setValue(nil, forKey: kfaceIdEnableEmailId)
            UserDefaults.standard.set(false, forKey: kEnableFaceIDKey)
        }
    }
    //configure
    
    func customizeButtons() { //and imageView etc.
        
        self.profileImageView.layer.masksToBounds = true
        self.profileImageView.layer.cornerRadius = 5
        self.profileImageView.layer.borderColor = UIColor.black.cgColor
        self.profileImageView.layer.borderWidth = 1
        
        self.pointsLabel.layer.masksToBounds = true
        self.pointsLabel.layer.cornerRadius = 5
        self.pointsLabel.layer.borderColor = UIColor.white.cgColor
        self.pointsLabel.layer.borderWidth = 1
        
        for view in self.view.subviews {
            
            if view is UIButton {
                
                view.layer.masksToBounds = true
                view.layer.cornerRadius = 5
                view.layer.borderColor = UIColor.white.cgColor
                view.layer.borderWidth = 1
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        customizeButtons()
        
        let uid = FIRAuth.auth()?.currentUser?.uid
        
        DataService.sharedManager.queryForUsers() { (userArray) in
            
            for theUser in userArray! {
                
                if theUser.uid == uid {
                    
                    self.currentUser = theUser
                    
                    print("CURRENT USER ID: \(theUser.uid)\(FIRAuth.auth()?.currentUser?.uid)")
                    print("CURRENT USER KEY: \(self.currentUser.key!)")
                    DataService.sharedManager.reference.child("Users").child(self.currentUser.key!).observe(.value, with: { (snappy) in
                        
                        if snappy.exists() {
                            
                            print("SNAPPY YES I DID IT: \(snappy.value)")
                            
                        }
                    })
                }
            }
        }
        
        self.tabBarController?.navigationItem.title = ""
        self.tabBarController?.navigationItem.rightBarButtonItem = nil

    }

    @IBAction func toggleImagePicker(_ sender: AnyObject) {
        
        imagePickerController.sourceType = UIImagePickerControllerSourceType.savedPhotosAlbum
        imagePickerController.delegate = self
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    @IBAction func saveProfile(_ sender: AnyObject) {
        
        let downloadURL = self.downloadURLString
        let displayName = self.displayNameField.text
        
        if downloadURL != "" && downloadURL != nil && self.currentUser.key != nil {

            DataService.sharedManager.reference.child("Users").child(self.currentUser.key!).child(kProfilePicURLKey).setValue(downloadURL)
            
            popAlert("Profile Saved!", message: "Your Information Has Been Saved")
        }
            
        if displayName != "" && self.currentUser.key != nil {
            
        DataService.sharedManager.reference.child("Users").child(self.currentUser.key!).child(kUsernameKey).setValue(displayName)
            
            popAlert("Profile Saved!", message: "Your Information Has Been Saved")
        }
        
        else {
            
            //do something
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func popAlert(_ title: String, message: String) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okayAction = UIAlertAction(title: "Okay!", style: .cancel, handler: nil)
        alertController.addAction(okayAction)
        
        self.present(alertController, animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        self.chosenImage = image
        self.profileImageView.image = self.chosenImage
        self.chosenImageData = UIImageJPEGRepresentation(self.chosenImage!, 0.2)
        self.dismiss(animated: true, completion: nil)
        
        DispatchQueue.global().async {
           self.uploadImageDataToFirebase(self.chosenImageData!)
        }
    }
    
    func uploadImageDataToFirebase(_ data: Data?) {
        
        guard let dataToSend = data else { print("no picture data"); return }
        
        let childString = NSString(format: "Image %@", UUID().uuidString)
        
        let profilePicsRef = DataService.sharedManager.storageReference.child("userProfilePics").child(childString as String)
        
        //the upload task 
        
        let uploadTask = profilePicsRef.put(dataToSend, metadata: nil) { (metadata, error) in
            
            if error != nil {
                print("Error uploading: \(error?.localizedDescription)")
            }
            
            else {
                print("Metadata: \(metadata)")
            }
        }
        
        uploadTask.observe(.success) { (taskSnapshot) in
            
            print("Image uploaded succesfully!")
            print("Task snapshot: \(taskSnapshot)")
            
            self.downloadURLString = (taskSnapshot.metadata?.downloadURL()?.absoluteString)!
            
            print("Download URL string \(self.downloadURLString!)")
            
        }
    }
}

extension ProfileViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
    }
}
