//
//  OtherProfileViewController.swift
//  CleanUpYourCity
//
//  Created by Jared Long on 5/12/19.
//  Copyright © 2019 Group3. All rights reserved.
//

import UIKit
import Firebase

class OtherProfileViewController: UIViewController {

    var event: Event!
    
    var ref: DatabaseReference!
    
    @IBOutlet weak var userLabel: UILabel!
    
    @IBOutlet weak var bioLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
         print(event.eventPoster)
        let userID = event.eventPoster as? String
        
        self.ref = Database.database().reference();
        ref.child("profile").child(userID!).observeSingleEvent(of: .value) { (snapshot) in
            let value = snapshot.value as? NSDictionary
            self.userLabel.text = value?["username"] as? String ?? ""
            self.bioLabel.text = value?["bio"] as? String ?? ""
        };    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
