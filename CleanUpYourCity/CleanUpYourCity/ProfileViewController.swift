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
    
    var ref: DatabaseReference!
    
    let userID = Auth.auth().currentUser?.uid;
    
    var eventList = [Event]()
        
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    
    
    @IBOutlet weak var historyTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let StorageRef = Storage.storage().reference()
        
        let StorageRefChild = StorageRef.child("profileImages/\(String(describing: userID)).jpeg")
        
        let imageView: UIImageView = self.profileImage
        
        let placeholderImage = UIImage(named: "placeholder.jpg")
        
        imageView.sd_setImage(with: StorageRefChild, placeholderImage: placeholderImage)
        
        self.ref = Database.database().reference();
        
        ref.child("profile").child(userID!).observeSingleEvent(of: .value) { (snapshot) in
            let value = snapshot.value as? NSDictionary
            self.userLabel.text = value?["username"] as? String ?? ""
            self.bioLabel.text = value?["bio"] as? String ?? ""
        };
        
        ref.child("profile").child(userID!).child("history").observe(DataEventType.value) { (snapshot) in
            if snapshot.childrenCount > 0 {
                
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
        event = eventList[indexPath.row]
        
        cell.nameLabel.text = event.eventName
        cell.descriptionLabel.text = event.eventDescription
        cell.severityLabel.text = event.eventSeverity
        
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
