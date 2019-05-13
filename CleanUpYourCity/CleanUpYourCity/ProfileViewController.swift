//
//  ProfileViewController.swift
//  CleanUpYourCity
//
//  Created by Lucas Montanari on 4/29/19.
//  Copyright © 2019 Group3. All rights reserved.
//

import UIKit
import Firebase
import AlamofireImage
import FirebaseStorage
import FirebaseDatabase
import FirebaseUI

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    // database and user id reference
    var ref: DatabaseReference!
    let userID = Auth.auth().currentUser?.uid;
    
    // list of event history we are going to use
    var eventList = [Event]()
    
    // outlets from Profile storyboard
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    
    @IBOutlet weak var historyTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // getting the image reference and making a placeholder for the image
        let StorageRef = Storage.storage().reference()
        let StorageRefChild = StorageRef.child("profileImages/\(String(describing: userID)).jpeg")
        let imageView: UIImageView = self.profileImage
        let placeholderImage = UIImage(named: "placeholder.jpg")
        
        // setting the image to the imageview
        imageView.sd_setImage(with: StorageRefChild, placeholderImage: placeholderImage)
        
        // initializing the database
        self.ref = Database.database().reference();
        
        // getting the users name and bio from the database
        ref.child("profile").child(userID!).observeSingleEvent(of: .value) { (snapshot) in
            let value = snapshot.value as? NSDictionary
            
            // setting the labels on the storyboard
            self.userLabel.text = value?["username"] as? String ?? ""
            self.bioLabel.text = value?["bio"] as? String ?? ""
        };
        
        // getting the event history of the user
        ref.child("profile").child(userID!).child("history").observe(DataEventType.value) { (snapshot) in
            if snapshot.childrenCount > 0 {
                // going through all the events in history for the current user
                for events in snapshot.children.allObjects as! [DataSnapshot] {
                    
                    let eventObject = events.value as? [String: AnyObject]
                    let poster  = eventObject?["eventAuthorID"]
                    let description  = eventObject?["eventDescription"]
                    let severity  = eventObject?["eventSeverity"]
                    let name = eventObject?["eventName"]
                    let icon = eventObject?["eventIcon"]
                    
                    //creating event object with model and fetched values
                    let event = Event(eventSeverity: severity as! String?,
                                      eventDescription: description as! String?,
                                      eventPoster: poster as! String?,
                                      eventName: name as! String?,
                                      eventIcon: icon as! String?)
                    
                    
                    //appending it to list
                    self.eventList.append(event)
                }
                //reloading the tableview
                self.historyTableView.reloadData()
            }
        };
        
        
        self.historyTableView.delegate = self;
        self.historyTableView.dataSource = self;
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(eventList.count)
        return eventList.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = historyTableView.dequeueReusableCell(withIdentifier: "historyCell", for: indexPath) as! historyCell;
        let event: Event!
        // getting the event per row
        event = eventList[indexPath.row]
        
        // setting the cell labels
        cell.nameLabel.text = event.eventName
        cell.descriptionLabel.text = event.eventDescription
        cell.severityLabel.text = event.eventSeverity
        
        // setting the cell color based off severity
        if(event.eventSeverity == "0"){
            cell.backgroundColor = UIColor.green
        }
        else if(event.eventSeverity == "1"){
            cell.backgroundColor = UIColor.cyan
        }
        else if(event.eventSeverity == "2"){
            cell.backgroundColor = UIColor.yellow
        }
        else if(event.eventSeverity == "3"){
            cell.backgroundColor = UIColor.red
        }
        
        return cell;
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func onLogoutButton(_ sender: Any) {
        try! Auth.auth().signOut()
        
        let main = UIStoryboard(name: "Main", bundle: nil)
        let homeView = main.instantiateViewController(withIdentifier: "loginView")
        self.present(homeView, animated: false, completion: nil);
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
