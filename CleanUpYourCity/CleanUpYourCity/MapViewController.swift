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
    @IBOutlet weak var bkgrd: UIView!
    
    //var gMapView: GMSMapView!
    var refEvent: DatabaseReference!
    var refRGB: DatabaseReference!
    
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var zoomLevel: Float = 15.0
    
    let userID = Auth.auth().currentUser?.uid;
    
    var eventList = [Event]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        locationManager.requestAlwaysAuthorization()
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.distanceFilter = 50
        
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        
        
        locationManager.delegate = self as CLLocationManagerDelegate
        locationManager.requestWhenInUseAuthorization()
        
        refEvent = Database.database().reference().child("events");
        
        //    let camera = GMSCameraPosition.camera(withLatitude: 36.652, longitude: -121.797, zoom: 4)
        let camera = GMSCameraPosition.camera(withLatitude: +37.78583400, longitude: -122.40641700, zoom: 14)
        //  let gMapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        
        let gMapView = GMSMapView.map(withFrame: CGRect(x: 16, y: 86, width: 343, height: 248), camera: camera)
        
        //  gMapView.center = self.view.center
        let bk = UIColor.green
        bkgrd.backgroundColor = bk
        self.view.addSubview(bkgrd)
        self.view.addSubview(gMapView)
        
        self.view.addSubview(tableView)
        
        gMapView.settings.myLocationButton = true
        gMapView.settings.compassButton = false
        
        gMapView.isMyLocationEnabled = true
        gMapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        //   var subviews: [UIView] { get gmap }
        //    view = gMapView
        
        // gmap = gMapView
        
        self.gMapView.camera = camera
        
        
        
        
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
                    let severity  = eventObject?["eventSeverity"]
                    let name = eventObject?["eventName"]
                    let icon = eventObject?["eventIcon"]
                    
                    let long = eventObject?["eventLocLon"] as? Double//CLLocationDegrees
                    let lat = eventObject?["eventLocLat"] as? Double//CLLocationDegrees
                    
                    let loc = CLLocation(latitude: lat ?? +37.78583400, longitude: long ?? -122.40641700)
                    
                    //creating event object with model and fetched values
                    let event = Event(eventSeverity: severity as! String?,
                                      eventDescription: description as! String?,
                                      eventPoster: poster as! String?,
                                      eventName: name as! String?,
                                      eventIcon: icon as! String?)
                    
                    var color = UIColor.orange
                    if(event.eventSeverity == "0"){
                        color = UIColor.green
                    }
                    else if(event.eventSeverity == "1"){
                        color = UIColor.cyan
                    }
                    else if(event.eventSeverity == "2"){
                        color = UIColor(red: 1, green: 1, blue: 153/255, alpha: 1)
                        
                        //color = UIColor.orange
                    }
                    else if(event.eventSeverity == "3"){
                        color = UIColor.red
                    }
                    print(name as! Any, loc.coordinate.latitude as! Any, loc.coordinate.longitude as! Any)
                    
                    let marker = GMSMarker()
                    
                    marker.position = CLLocationCoordinate2D(latitude: loc.coordinate.latitude, longitude: loc.coordinate.longitude)
                    
                    marker.title = (name as! String)
                    print(loc.coordinate.longitude as! Double)
                    marker.snippet = (description as! String)
                    
                    marker.icon = GMSMarker.markerImage(with: color)
                    marker.appearAnimation = GMSMarkerAnimation.pop
                    
                    marker.map = gMapView
                    // gMapView.camera = camera
                    
                    if let mylocation = gMapView.myLocation {
                        print("User's location: \(mylocation)")
                    } else {
                        print("User's location is unknown")
                    }
                    
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
        
        print(event.eventSeverity as Any)
        
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
        
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension MapViewController: CLLocationManagerDelegate {
    // Populate the array with the list of likely places.
    //    func listLikelyPlaces() {
    //        // Clean up from previous sessions.
    //       // listLikelyPlaces().removeAll()
    //
    //        placesClient.currentPlace(callback: { (placeLikelihoods, error) -> Void in
    //            if let error = error {
    //                // TODO: Handle the error.
    //                print("Current Place error: \(error.localizedDescription)")
    //                return
    //            }
    //
    //            // Get likely places and add to the list.
    //            if let likelihoodList = placeLikelihoods {
    //                for likelihood in likelihoodList.likelihoods {
    //                    let place = likelihood.place
    //                    self.listLikelyPlaces().append(place)
    //                }
    //            }
    //        })
    //    }
    
    // Handle incoming location events.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.last!
        print("Location: \(location)")
        
        //  let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude,longitude: location.coordinate.longitude, zoom: zoomLevel)
        
        //        if gMapView.isHidden {
        //            gMapView.isHidden = false
        //            gMapView.camera = camera
        //        } else {
        //            gMapView.animate(to: camera)
        //        }
        
        //  listLikelyPlaces()
    }
    
    // Handle authorization for the location manager.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted:
            print("Location access was restricted.")
        case .denied:
            print("User denied access to location.")
            // Display the map using the default location.
            gMapView.isHidden = false
        case .notDetermined:
            print("Location status not determined.")
        case .authorizedAlways: fallthrough
        case .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
            
            print("Location status is OK.")
        }
    }
    
    // Handle location manager errors.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        print("Error: \(error)")
    }
}

