//
//  SearchRestaurantViewController.swift
//  Sooma
//
//  Created by Ethan Hess on 9/3/16.
//  Copyright © 2016 Ethan Hess. All rights reserved.
//

import UIKit
import CoreLocation

class SearchRestaurantViewController: UIViewController, AddNameDelegate {

    @IBOutlet var activityView: UIActivityIndicatorView!
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var tableView: UITableView!
    
    var localRestaurantArray : [Restaurant] = []
    var filteredRestaurants : [Restaurant] = []
    
    var localYelpRestaurantArray : [YelpEstablishment] = []
    var localYelpFilteredArray : [YelpEstablishment] = []
    
    var localWaitTimeArray : [WaitTime] = []
    
    var restaurantToPass : Restaurant?
    var yelpToPass : YelpEstablishment?
    
    var waitStringToPass : String?
    
    var isFiltering = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.navigationItem.title = "Search Restaurants"
        
        //getDataWrapperFunction()
        
        //DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
        
        self.getDataFromYelp()
        
        //}
        
        getWaitTimes()
    }
    
    func getWaitTimes() {
        
        self.localWaitTimeArray = []
        
        DataService.sharedManager.reference.child("WaitTimes").observe(.value, with: { (snapshot) in
            
            if (snapshot.exists()) {
                
                print("SNAPSHOT : \(snapshot)")
                
                let snapArray = snapshot.children.allObjects as! [FIRDataSnapshot]
                
                for dictSnap in snapArray {
                    
                let dict = dictSnap.value as! NSDictionary
                
                print("Dict : \(dict)")
                
                let name = dictSnap.key 
                    
                let valueArray = dict.allValues as! [Int]
                
                print("Name \(name)\(valueArray)")
                
                let waitTime = WaitTime(restaurantName: name, timeArray: valueArray)
                
                self.localWaitTimeArray.append(waitTime)
                    
                }
                
                print("Wait times: \(self.localWaitTimeArray)")
                
                self.refresh()
            }
        })
    }
    
    func getDataWrapperFunction() {
        
        self.localRestaurantArray = []
        
        LocationFunctions.sharedInstance.locationWithComplete { (currentLocation) in
            
            self.fetchRestaurantData(currentLocation.latitude, long: currentLocation.longitude)
            
        }
    }
    
    func getDataFromYelp() {
        
        self.activityView.startAnimating()
        
        self.localYelpRestaurantArray = []
        
        NetworkController.sharedInstance.getYelpDataAlamofire { (yelpEstablishments) in
            
            if (yelpEstablishments != nil) {
                
                self.localYelpRestaurantArray = yelpEstablishments!
                
                DispatchQueue.main.async {
                
                    self.activityView.stopAnimating()
                    
                }
                
                self.refresh()
            }
        }
    }
    
    func refresh() {
        
        DispatchQueue.main.async {
           self.tableView.reloadData()
        }
    }
    
    func fetchRestaurantData(_ lat: CLLocationDegrees, long: CLLocationDegrees) {
        
        let urlToPass = URL(string: "https://developers.zomato.com/api/v2.1/geocode?lat=\(lat)&lon=\(long)")
        
        NetworkController.sharedInstance.grabRestaurantData(urlToPass!) { (resultData) in
            
            let data = self.dataToJSON(resultData!)
            
            let dictionary = data as! NSDictionary
            
            let resultsArray = dictionary["nearby_restaurants"] as! NSArray
            
            for restaurantDict in resultsArray {
                
                print("RESTAURANT: \(restaurantDict)")
                
                let initDict = restaurantDict as! Dictionary<String, Any>
            
                let initSubDict = initDict["restaurant"]
                
                let restaurant = Restaurant(initSubDict as! Dictionary<String, Any>)
                
                print("RESTAURANT: \(restaurant)")
                
                self.localRestaurantArray.append(restaurant)
            }
            
            DispatchQueue.main.async {
                
                self.refresh()
            }
        }
    }
    
    func dataToJSON(_ data: Data) -> Any? {
        
        do {
            return try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
        } catch let myJSONError {

            print("ERROR \(myJSONError)")
        }
        return nil
    }
    
    
    func performSegueFunction() {
        
        self.performSegue(withIdentifier: "putNameDown", sender: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    func saveWaitTimeWithRestaurant(restaurant: Restaurant, waitTime: Int) {
//        
//        DataService.sharedManager.reference.child("WaitTimes").child(restaurant.name).childByAutoId().setValue(waitTime)
//        
//        self.popAlert(title: "Wait time has been added!", message: "")
//        
//        refresh()
//    }
    
    func saveWaitTimeWithRestaurant(restaurant: YelpEstablishment, waitTime: Int) {
        
        DataService.sharedManager.reference.child("WaitTimes").child(restaurant.name).childByAutoId().setValue(waitTime)
        
        self.popAlert(title: "Wait time has been added!", message: "")
        
        refresh()
    }
    
    func addWaitTime(restaurant: YelpEstablishment) {
        
        let alertController = UIAlertController(title: "Add wait time", message: "Please enter the approximate wait time for this restaurant", preferredStyle: .alert)
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Wait time"
        }
        
        alertController.textFields?[0].keyboardType = UIKeyboardType.decimalPad
        alertController.textFields?[0].delegate = self
        
        let addAction = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let waitTime = alertController.textFields?[0].text
            
            self.saveWaitTimeWithRestaurant(restaurant: restaurant, waitTime: Int(waitTime!)!)
        }
        
        let cancelAction = UIAlertAction(title: "Nevermind", style: .cancel, handler: nil)
        
        alertController.addAction(addAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
//    func addWaitTime(restaurant: Restaurant) {
//        
//        let alertController = UIAlertController(title: "Add wait time", message: "Please enter the approximate wait time for this restaurant", preferredStyle: .alert)
//        
//        alertController.addTextField { (textField) in
//            textField.placeholder = "Wait time"
//        }
//        
//        alertController.textFields?[0].keyboardType = UIKeyboardType.decimalPad
//        alertController.textFields?[0].delegate = self
//        
//        let addAction = UIAlertAction(title: "Add", style: .default) { (action) in
//            
//            let waitTime = alertController.textFields?[0].text
//            
//            self.saveWaitTimeWithRestaurant(restaurant: restaurant, waitTime: Int(waitTime!)!)
//        }
//        
//        let cancelAction = UIAlertAction(title: "Nevermind", style: .cancel, handler: nil)
//        
//        alertController.addAction(addAction)
//        alertController.addAction(cancelAction)
//        
//        self.present(alertController, animated: true, completion: nil)
//    }
    
//    func addNameWithRestaurant(restaurant: Restaurant) {
//        
//        print("REST NAME \(restaurant.name)")
//        
//        let alertController = UIAlertController(title: "Add name to \(restaurant.name)?", message: "", preferredStyle: .alert)
//        
//        let alertActionOne = UIAlertAction(title: "Yes", style: .default) { (action) in
//            
//            if let uidToAdd = FIRAuth.auth()?.currentUser?.uid {
//                DataService.sharedManager.reference.child("Requests").child(restaurant.name).child("requesters").childByAutoId().setValue(uidToAdd)
//                
//                self.popAlert(title: "Your name has been added to the list at \(restaurant.name)!", message: "")
//            }
//        }
//        
//        let alertActionTwo = UIAlertAction(title: "No thanks", style: .cancel, handler: nil)
//        
//        alertController.addAction(alertActionOne)
//        alertController.addAction(alertActionTwo)
//        
//        self.present(alertController, animated: true, completion: nil)
//    }
    
    func addNameWithYelpRestaurant(yelpRestaurant: YelpEstablishment) {
        
        print("REST NAME \(yelpRestaurant.name)")
        
        let alertController = UIAlertController(title: "Add name to \(yelpRestaurant.name)?", message: "", preferredStyle: .alert)
        
        let alertActionOne = UIAlertAction(title: "Yes", style: .default) { (action) in
            
            if let uidToAdd = FIRAuth.auth()?.currentUser?.uid {
                DataService.sharedManager.reference.child("Requests").child(yelpRestaurant.name).child("requesters").childByAutoId().setValue(uidToAdd)
                
                self.popAlert(title: "Your name has been added to the list at \(yelpRestaurant.name)!", message: "")
            }
        }
        
        let alertActionTwo = UIAlertAction(title: "No thanks", style: .cancel, handler: nil)
        
        alertController.addAction(alertActionOne)
        alertController.addAction(alertActionTwo)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func popAlert(title: String, message: String) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let alertActionOkay = UIAlertAction(title: "Okay!", style: .cancel, handler: nil)
        
        alertController.addAction(alertActionOkay)
        self.present(alertController, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toDetail" {
            
            //if (self.restaurantToPass != nil) {
            
            if (self.yelpToPass != nil && self.waitStringToPass != nil) {
        
            let destinationVC = segue.destination as! RestaurantDetailViewController
            //destinationVC.setRestaurant(restaurant: restaurantToPass!)
                
                destinationVC.setRestaurant(yelpRestaurant: yelpToPass!)
                destinationVC.waitTime = self.waitStringToPass
            }
        }
    }
}

extension SearchRestaurantViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let cell = tableView.cellForRow(at: indexPath) as! RestaurantTableViewCell
        
        if isFiltering == false {
            
            yelpToPass = localYelpRestaurantArray[indexPath.row]
            waitStringToPass = cell.waitTimeLabel.text
            
            //restaurantToPass = localRestaurantArray[indexPath.row]
            self.performSegue(withIdentifier: "toDetail", sender: nil)
            
        } else {
            
            yelpToPass = localYelpFilteredArray[indexPath.row]
            waitStringToPass = cell.waitTimeLabel.text
            
            //restaurantToPass = filteredRestaurants[indexPath.row]
            self.performSegue(withIdentifier: "toDetail", sender: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isFiltering == false {
            
            return localYelpRestaurantArray.count
            //return localRestaurantArray.count
        } else {
            
            return localYelpFilteredArray.count
            //return filteredRestaurants.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! RestaurantTableViewCell
        
        cell.delegate = self
        
        if self.isFiltering == false {
        
        //if self.localRestaurantArray.count > 0 {
            
        if self.localYelpRestaurantArray.count > 0 {
        
            //let restaurant : Restaurant = self.localRestaurantArray[indexPath.row]
            let yelpRestaurant : YelpEstablishment = self.localYelpRestaurantArray[indexPath.row]
        
            //cell.theRestaurant = restaurant
            cell.yelpRestaurant = yelpRestaurant
            
            //cell.nameLabel.text = restaurant.name
            cell.nameLabel.text = yelpRestaurant.name
            
            //let waitString = deciferWaitTimeForRestaurant(restaurant: restaurant)
            let waitString = deciferWaitTimeForYelpRestaurant(yelpRestaurant: yelpRestaurant)
            
            if waitString == "No wait time" {
                
                cell.waitTimeLabel.text = waitString
            }
            
            else {
                cell.waitTimeLabel.text = "\(waitString) minutes"
            }
            
//        if restaurant.imageURL != nil && restaurant.imageURL != "" {
//        
//            cell.setImageFromURLString(theURLstring: restaurant.imageURL)
//        }
            
            if yelpRestaurant.imageURL != "" {
                
                cell.setImageFromURLString(theURLstring: yelpRestaurant.imageURL)
            }
        }
        }
        
        else {
            
            if self.filteredRestaurants.count > 0 {
                
                //let restaurant : Restaurant = self.filteredRestaurants[indexPath.row]
                
                let yelpRestaurant : YelpEstablishment = self.localYelpFilteredArray[indexPath.row]
                
                //cell.theRestaurant = restaurant
                cell.yelpRestaurant = yelpRestaurant
                
                //cell.nameLabel.text = restaurant.name
                cell.nameLabel.text = yelpRestaurant.name
                
                //let waitString = deciferWaitTimeForRestaurant(restaurant: restaurant)
                let waitString = deciferWaitTimeForYelpRestaurant(yelpRestaurant: yelpRestaurant)
                
                if waitString == "No wait time" {
                    
                    cell.waitTimeLabel.text = waitString
                }
                    
                else {
                    cell.waitTimeLabel.text = "\(waitString) minutes"
                }
                
//                if restaurant.imageURL != nil && restaurant.imageURL != "" {
//                    
//                    cell.setImageFromURLString(theURLstring: restaurant.imageURL)
//                }
                
                if yelpRestaurant.imageURL != "" {
                    
                    cell.setImageFromURLString(theURLstring: yelpRestaurant.imageURL)
                }
            }
        }

        return cell
    }
    
    func deciferWaitTimeForYelpRestaurant(yelpRestaurant: YelpEstablishment) -> String {
        
        var hasWaitTime = false
        var waitTimeToSync : WaitTime?
        
        for waitTime in localWaitTimeArray {
            
            if waitTime.restaurantName == yelpRestaurant.name {
                
                hasWaitTime = true
                waitTimeToSync = waitTime
            }
        }
        
        if hasWaitTime == true {
            
            if (waitTimeToSync?.timeArray.count == 1) {
                
                return String(waitTimeToSync!.timeArray[0])
                
            }
                
            else {
                
                return String(self.calculateTime(arrayOfInts: waitTimeToSync!.timeArray))
            }
        }
            
        else {
            
            return "No wait time"
        }
    }
    
    //When not using yelp
    
//    func deciferWaitTimeForRestaurant(restaurant: Restaurant) -> String {
//        
//        var hasWaitTime = false
//        var waitTimeToSync : WaitTime?
//        
//        for waitTime in localWaitTimeArray {
//            
//            if waitTime.restaurantName == restaurant.name {
//                
//                hasWaitTime = true
//                waitTimeToSync = waitTime
//            }
//        }
//        
//        if hasWaitTime == true {
//            
//            if (waitTimeToSync?.timeArray.count == 1) {
//                
//                return String(waitTimeToSync!.timeArray[0])
//                
//            }
//                
//            else {
//                
//                return String(self.calculateTime(arrayOfInts: waitTimeToSync!.timeArray))
//            }
//        }
//        
//        else {
//            
//            return "No wait time"
//        }
//    }
    
    func calculateTime(arrayOfInts: [Int]) -> Float {
        
        let count = arrayOfInts.count
        
        let summedArray = arrayOfInts.reduce(0, {$0 + $1})
        
        let finalSum = summedArray / count
        
        return Float(finalSum)
    }

}

extension SearchRestaurantViewController: UITextFieldDelegate {
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
    }
}

extension SearchRestaurantViewController: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        isFiltering = false
        
        self.view.endEditing(true)
        
        //getDataWrapperFunction()
        getDataFromYelp()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        self.filterContentForSearchText(searchText: searchBar.text!)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        self.filterContentForSearchText(searchText: searchBar.text!)
        
        isFiltering = true
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
        
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
        isFiltering = false
        
        self.tableView.reloadData()
    }
    
    func filterContentForSearchText(searchText: String) {
        
        //var newTempEmptyArray : [Restaurant] = []
        var newTempEmptyArray : [YelpEstablishment] = []
        
        //for resturant in self.localRestaurantArray {
        
        for restaurant in self.localYelpRestaurantArray {
            
            if restaurant.name.contains(searchText) {
                
                newTempEmptyArray.append(restaurant)
                //self.filteredRestaurants = newTempEmptyArray
                self.localYelpFilteredArray = newTempEmptyArray
            }
        }
        
        refresh()
    }
}
