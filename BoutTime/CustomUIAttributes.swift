//
//  UILabelAttributes.swift
//  BoutTime
//
//  Created by Sherief Wissa on 21/11/16.
//  Copyright © 2016 10 Red Hacks Pty Ltd. All rights reserved.
//

import Foundation
import UIKit


class CustomLabelAttributes:UILabel{
    
    var labelSequence:Int = value(forKeyPath: "labelSequence") as! Int
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
}


class CustomButtonAttributes:UIButton{
    
    let moveDirection: String = ""
    let inLabelNo: Int = 0
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
}
