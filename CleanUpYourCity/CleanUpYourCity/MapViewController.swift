//
//  MapViewController.swift
//  CleanUpYourCity
//
//  Created by Diana Danvers on 4/15/19.
//  Copyright © 2019 Group3. All rights reserved.
//

import UIKit
import GoogleMaps
import Firebase

class GarbageTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var eventPic: UIImageView!
    @IBOutlet weak var eventName: UILabel!
    @IBOutlet weak var eventDescription: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

class MapViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var gMapView: GMSMapView!


    var refEvent: DatabaseReference!
    var refRGB: DatabaseReference!

    let userID = Auth.auth().currentUser?.uid;

    var eventList = [Event]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refEvent = Database.database().reference().child("events");

        let camera = GMSCameraPosition.camera(withLatitude: 36.652, longitude: -121.797, zoom: 17)
        let mapView = GMSMapView.map(withFrame: .zero, camera: camera)
        gMapView.camera = camera
        
        
        mapView.isMyLocationEnabled = true
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.reloadData()
        // Do any additional setup after loading the view.
        
//        eventList.removeAll()
        
        refEvent.observe(DataEventType.value, with: { (snapshot) in

                //if the reference have some values
                if snapshot.childrenCount > 0 {

                    //iterating through all the values
                    for events in snapshot.children.allObjects as! [DataSnapshot] {
                        
                        //getting values
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
                    self.tableView.reloadData()
                }
            })
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return eventList.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        //creating a cell using the custom class
        let cell = tableView.dequeueReusableCell(withIdentifier: "Event Cell", for: indexPath) as! GarbageTableViewCell
        cell.backgroundColor = UIColor.orange
        //the artist object
        let event: Event
        let tempIcon = "8"
        //getting the artist of selected position
        event = eventList[indexPath.row]
        
        //adding values to labels

        cell.eventPic.image = UIImage(named: event.eventIcon ?? tempIcon)
        cell.eventDescription.text = event.eventDescription
        cell.eventName.text = event.eventName
        
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
        else {
            cell.backgroundColor = UIColor.orange
        }
        
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
