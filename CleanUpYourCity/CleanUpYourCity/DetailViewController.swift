//
//  DetailViewController.swift
//  CleanUpYourCity
//
//  Created by Jared Long on 5/13/19.
//  Copyright © 2019 Group3. All rights reserved.
//

import UIKit
import Firebase

class DetailViewController: UIViewController {

    var event: Event!
    
    var ref: DatabaseReference!
    
    
    @IBOutlet weak var eventTitleLabel: UILabel!
    @IBOutlet weak var eventPosterButton: UIButton!
    @IBOutlet weak var eventDescriptionLabel: UILabel!
    @IBOutlet weak var eventIconView: UIImageView!
    
    @IBOutlet weak var eventIconDescriptionLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        //print(event.eventPoster)
        eventTitleLabel.text = event.eventName
        eventTitleLabel.sizeToFit()
        eventDescriptionLabel.text = event.eventDescription
        eventDescriptionLabel.sizeToFit()
        
        let tempIcon = "8"
        
        eventIconView.image = UIImage(named: event.eventIcon ?? tempIcon)
        
        self.ref = Database.database().reference();
        ref.child("profile").child(event.eventPoster!).observeSingleEvent(of: .value) { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let username = value?["username"] as? String ?? ""
            self.eventPosterButton.setTitle(username, for: .normal)
            self.eventPosterButton.sizeToFit()
            
        };
        
        if(event.eventIcon == "0")
        {
            eventIconDescriptionLabel.text = "This event involves generic everyday trash and litter"
        }
        else if(event.eventIcon == "1")
        {
            eventIconDescriptionLabel.text = "This event involves recyleable objects such as bottles, paper, boxes, etc."
        }
        else if(event.eventIcon == "2")
        {
            eventIconDescriptionLabel.text = "This event involves green waste such as leaves, branches, weeds, etc."
        }
        else if(event.eventIcon == "3")
        {
            eventIconDescriptionLabel.text = "This event involves electronic waste such as computers, cables, batteries, chargers, etc."
        }
        else if(event.eventIcon == "4")
        {
            eventIconDescriptionLabel.text = "This event involves refuse such as animal waste or human waste."
        }
        else if(event.eventIcon == "5")
        {
            eventIconDescriptionLabel.text = "This event involves needles or other dangerous sharp objects. Be careful!"
        }
        else if(event.eventIcon == "6")
        {
            eventIconDescriptionLabel.text = "This event involves oil spills, toxic chemicals, or other dangerous materials. Contact your local government immeditately!"
        }
        else if(event.eventIcon == "7")
        {
            eventIconDescriptionLabel.text = "This event involves biohazardous waste, radioactive waste, or other dangerous materials. Contact your local government immeditately!"
        }
        
        
        if( event.eventSeverity == "0")
        {
            self.view.backgroundColor = UIColor.green
        }
        else if( event.eventSeverity == "1")
        {
            self.view.backgroundColor = UIColor.cyan
        }
        else if( event.eventSeverity == "2")
        {
            self.view.backgroundColor = UIColor.yellow
        }
        else if( event.eventSeverity == "3")
        {
            self.view.backgroundColor = UIColor.red
        }
    }
    
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        
        if segue.identifier == "OtherProfileID"
        {
            
            // Pass the selected object to the new view controller.
            let otherProfileViewController = segue.destination as! OtherProfileViewController
            
            otherProfileViewController.event = self.event
            
        }
        
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
