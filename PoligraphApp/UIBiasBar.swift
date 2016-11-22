//
//  UIBiasBar.swift
//  PoligraphApp
//
//  Created by Kent Blake on 11/21/16.
//  Copyright © 2016 Silo Busters. All rights reserved.
//

import UIKit

class UIBiasBar: UISlider {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override func trackRect(forBounds: CGRect) -> CGRect {
        return CGRect (x: 0, y: 0, width: bounds.size.width, height: 4)
    }

}
