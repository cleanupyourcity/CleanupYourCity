//
//  AddEventViewController.swift
//  CleanUpYourCity
//
//  Created by Jared Long on 5/6/19.
//  Copyright © 2019 Group3. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase

class AddEventViewController: UIViewController {

    var ref:DatabaseReference?
    
    let userID = Auth.auth().currentUser?.uid;
    
    @IBOutlet weak var eventNameField: UITextField!
    
    @IBOutlet weak var eventDescriptionField: UITextView!
    
    @IBOutlet weak var eventSeverityController: UISegmentedControl!
    
    //icon buttons
    @IBOutlet weak var genericButton: UIButton!
    @IBOutlet weak var recyclingButton: UIButton!
    @IBOutlet weak var greenWasteButton: UIButton!
    @IBOutlet weak var eWasteButton: UIButton!
    @IBOutlet weak var refuseButton: UIButton!
    @IBOutlet weak var needleButton: UIButton!
    @IBOutlet weak var toxicWasteButton: UIButton!
    @IBOutlet weak var biohazardButton: UIButton!
    
    
    var iconNumber:String = "0"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        ref = Database.database().reference()
        
        self.view.backgroundColor = UIColor.green
       
        genericButton.tag = 0
        recyclingButton.tag = 1
        greenWasteButton.tag = 2
        eWasteButton.tag = 3
        refuseButton.tag = 4
        needleButton.tag = 5
        toxicWasteButton.tag = 6
        biohazardButton.tag = 7
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func severityLevelChanged(_ sender: Any) {
        
        let eventSeverityInteger: Int = eventSeverityController.selectedSegmentIndex
        
        let eventSeverityLevel = String(eventSeverityInteger)
        
        if( eventSeverityLevel == "0")
        {
            self.view.backgroundColor = UIColor.green
        }
        else if( eventSeverityLevel == "1")
        {
            self.view.backgroundColor = UIColor.cyan
        }
        else if( eventSeverityLevel == "2")
        {
            self.view.backgroundColor = UIColor.yellow
        }
        else if( eventSeverityLevel == "3")
        {
            self.view.backgroundColor = UIColor.red
        }
    }
    
    func changeButtonBackground()
    {
        for case let button as UIButton in self.view.subviews {
            if button.backgroundColor == UIColor.clear
            {
                
            }
            else if button.backgroundColor == UIColor.lightGray
            {
                button.backgroundColor = UIColor.white
            }
        
        }
        
    }

    
    @IBAction func changeEventIcon(_ sender: UIButton){
        if(sender.tag == 0)
        {
            changeButtonBackground()
            sender.backgroundColor = UIColor.lightGray
            iconNumber = "0"
            print(iconNumber)
        }
        else if(sender.tag == 1)
        {
            changeButtonBackground()
            sender.backgroundColor = UIColor.lightGray
            iconNumber = "1"
            print(iconNumber)
        }
        else if(sender.tag == 2)
        {
            changeButtonBackground()
            sender.backgroundColor = UIColor.lightGray
            iconNumber = "2"
            print(iconNumber)
        }
        else if(sender.tag == 3)
        {
            changeButtonBackground()
            sender.backgroundColor = UIColor.lightGray
            iconNumber = "3"
            print(iconNumber)
        }
        else if(sender.tag == 4)
        {
            changeButtonBackground()
            sender.backgroundColor = UIColor.lightGray
            iconNumber = "4"
            print(iconNumber)
        }
        else if(sender.tag == 5)
        {
            changeButtonBackground()
            sender.backgroundColor = UIColor.lightGray
            iconNumber = "5"
            print(iconNumber)
        }
        else if(sender.tag == 6)
        {
            changeButtonBackground()
            sender.backgroundColor = UIColor.lightGray
            iconNumber = "6"
            print(iconNumber)
        }
        else if(sender.tag == 7)
        {
            changeButtonBackground()
            sender.backgroundColor = UIColor.lightGray
            iconNumber = "7"
            print(iconNumber)
        }
    }
    
    
    @IBAction func addEvent(_ sender: Any) {
        
        //Post event data to firebase
        let key = ref?.childByAutoId().key
        
        let eventSeverityInteger: Int = eventSeverityController.selectedSegmentIndex
        
        let eventSeverityLevel = String(eventSeverityInteger)
        
        //creating artist with the given values
        let event = ["eventAuthorID":userID,
                      "eventName": eventNameField.text! as String,
                      "eventDescription": eventDescriptionField.text! as String,
                      "eventSeverity": eventSeverityLevel,
                      "eventIcon": iconNumber
        ]
        ref?.child("events").child(key!).setValue(event)
        ref?.child("profile").child(userID!).child("history").child(key!).setValue(event)
        self.navigationController?.popViewController(animated: true)    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
