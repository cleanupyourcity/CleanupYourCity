//
//  MapViewController.swift
//  CleanUpYourCity
//
//  Created by Diana Danvers on 4/15/19.
//  Copyright © 2019 Group3. All rights reserved.
//

import UIKit
import GoogleMaps

class MapViewController: UIViewController  {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var gMapView: GMSMapView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let camera = GMSCameraPosition.camera(withLatitude: 36.652, longitude: -121.797, zoom: 17)
        let mapView = GMSMapView.map(withFrame: .zero, camera: camera)
        gMapView.camera = camera
        
        mapView.isMyLocationEnabled = true
        //self.view = mapView
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.reloadData()
        // Do any additional setup after loading the view.
        
    }
}

extension MapViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Event Cell" , for: indexPath as IndexPath) as? GarbageTableViewCell
        cell!.eventName.text = "Event Demo"
        cell!.eventDesc.text = "Event Descprtion for u for me to give you all the love in the world :)"
        //        cell!.eventPic.image =
        return cell!
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        //return garbageArray.count
        return 5
    }
}
extension MapViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let indexPath = tableView.indexPathForSelectedRow
        _ = tableView.cellForRow(at: indexPath!)!
    }
}
