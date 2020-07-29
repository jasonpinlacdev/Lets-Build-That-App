//
//  UIView+EXT.swift
//  AutoLayout Programmatically
//
//  Created by Jason Pinlac on 7/28/20.
//  Copyright © 2020 Jason Pinlac. All rights reserved.
//

import UIKit

extension UIView {
    
    func turnOnRedBorder() {
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.systemRed.cgColor
    }
    
}
