//
//  historyCell.swift
//  CleanUpYourCity
//
//  Created by Lucas Montanari on 4/29/19.
//  Copyright © 2019 Group3. All rights reserved.
//

import UIKit

class historyCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var severityLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
