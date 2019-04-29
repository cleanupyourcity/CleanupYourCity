//
//  GarbageTableViewCell.swift
//  CleanUpYourCity
//
//  Created by Diana Danvers on 4/17/19.
//  Copyright © 2019 Group3. All rights reserved.
//

import UIKit

class GarbageTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var eventPic: UIImageView!
    @IBOutlet weak var eventName: UILabel!
    @IBOutlet weak var eventDesc: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
