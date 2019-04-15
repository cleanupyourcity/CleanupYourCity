//
//  CustomButton.swift
//  CleanUpYourCity
//
//  Created by Emmanuel Guido on 4/14/19.
//  Copyright © 2019 Group3. All rights reserved.
//

import UIKit

class CustomButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupButton()
    }
    
    
    private func setupButton() {
        backgroundColor     = UIColor.blue
        layer.cornerRadius  = frame.size.height/2
        setTitleColor(.white, for: .normal)
    }

}
