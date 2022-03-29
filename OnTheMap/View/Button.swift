//
//  Button.swift
//  OnTheMap
//
//  Created by Nathalie Cesarino on 14/03/22.
//

import UIKit

class Button: UIButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.cornerRadius = 5
        tintColor = UIColor.white
    }
}
