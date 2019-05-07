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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        ref = Database.database().reference()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addEvent(_ sender: Any) {
        
        //Post event data to firebase
        let key = ref?.childByAutoId().key
        
        //creating artist with the given values
        let event = ["eventAuthorID":userID,
                      "eventName": eventNameField.text! as String,
                      "eventDescription": eventDescriptionField.text! as String
        ]
        ref?.child("events").child(key!).setValue(event)
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
