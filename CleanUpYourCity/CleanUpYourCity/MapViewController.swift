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
    var eventList = [Event]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
       // FirebaseApp.configure()

        refEvent = Database.database().reference().child("events");
        
        let camera = GMSCameraPosition.camera(withLatitude: 36.652, longitude: -121.797, zoom: 17)
        let mapView = GMSMapView.map(withFrame: .zero, camera: camera)
        gMapView.camera = camera
        
        
        mapView.isMyLocationEnabled = true
        //self.view = mapView
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.reloadData()
        // Do any additional setup after loading the view.
            
        refEvent.observe(DataEventType.value, with: { (snapshot) in

                //if the reference have some values
                if snapshot.childrenCount > 0 {

                    //iterating through all the values
                    for events in snapshot.children.allObjects as! [DataSnapshot] {
                        
                        //getting values
                        let eventObject = events.value as? [String: AnyObject]
                        let poster  = eventObject?["eventAuthorID"]
                        let description  = eventObject?["eventDescription"]
                        let severity  = eventObject?["eventSeverityLevel"]
                        let name = eventObject?["eventName"]

                        //creating event object with model and fetched values
                        let event = Event(eventSeverityLevel: severity as! String?,
                                          eventDescription: description as! String?,
                                          eventPoster: poster as! String?,
                                          eventName: name as! String?)

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
        
        //the artist object
        let event: Event
        
        //getting the artist of selected position
        event = eventList[indexPath.row]
        
        //adding values to labels
        
              cell.eventDescription.text = event.eventDescription
        //     cell.eventDangerLevel.text = event.eventDangerLevel
        //    cell.eventPoster.text = event.eventPoster
           cell.eventName.text = event.eventName
        
        
        
      //  cell.eventName.text = "Event Demo"
       // cell.eventDescription.text = "Event Descprtion for u for me to give you all the love in the world :)"
        
        //returning cell
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

//
//extension MapViewController: UITableViewDataSource {
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "Event Cell" , for: indexPath as IndexPath) as? GarbageTableViewCell
//        cell!.eventName.text = "Event Demo"
//        cell!.eventDesc.text = "Event Descprtion for u for me to give you all the love in the world :)"
//        //        cell!.eventPic.image =
//        return cell!
//
//    }
//
//    func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 4
//    }
//
//
//}
//extension MapViewController: UITableViewDelegate{
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let indexPath = tableView.indexPathForSelectedRow
//        _ = tableView.cellForRow(at: indexPath!)!
//    }
//}
