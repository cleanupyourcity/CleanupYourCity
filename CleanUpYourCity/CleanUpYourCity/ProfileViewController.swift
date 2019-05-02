//
//  ProfileViewController.swift
//  CleanUpYourCity
//
//  Created by Lucas Montanari on 4/29/19.
//  Copyright © 2019 Group3. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var ref: DatabaseReference!
    
    let userID = Auth.auth().currentUser?.uid;
    
    public var historyCount: Int!
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    
    @IBOutlet weak var historyTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.ref = Database.database().reference();
        ref.child("profile").child(userID!).observeSingleEvent(of: .value) { (snapshot) in
            let value = snapshot.value as? NSDictionary
            self.userLabel.text = value?["username"] as? String ?? ""
            self.bioLabel.text = value?["bio"] as? String ?? ""
        };
        
        
        historyTableView.delegate = self;
        historyTableView.dataSource = self;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0;
        ref.child("profile").child(userID!).child("history").observeSingleEvent(of: .value) { (snapshot) in
            let value = snapshot.value as? NSDictionary
            count = (value?.count)!
        };
        print(count)
        return 1;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = historyTableView.dequeueReusableCell(withIdentifier: "historyCell") as! historyCell;
        
        
        ref.child("profile").child(userID!).child("history").child("eventID").observeSingleEvent(of: .value) { (snapshot) in
            let value = snapshot.value as? NSDictionary
            cell.nameLabel.text = value?["name"] as? String ?? ""
            cell.dateLabel.text = value?["date"] as? String ?? ""
            cell.severityLabel.text = value?["severity"] as? String ?? ""
            cell.pointsLabel.text = value?["points"] as? String ?? ""
        };
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
