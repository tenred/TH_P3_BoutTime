//
//  LabelBorderIndent.swift
//  BoutTime
//
//  Created by Sherief Wissa on 9/1/17.
//  Copyright © 2017 10 Red Hacks Pty Ltd. All rights reserved.
//
import UIKit

class UIBorderedLabel: UILabel {
    // Class is as an extension to the UILabel to indent text on left and right sides.

    var topInset:       CGFloat = 0
    var rightInset:     CGFloat = 5
    var bottomInset:    CGFloat = 0
    var leftInset:      CGFloat = 20
    
    override func drawText(in rect: CGRect) {
        let insets: UIEdgeInsets = UIEdgeInsets(top: self.topInset, left: self.leftInset, bottom: self.bottomInset, right: self.rightInset)
        self.setNeedsLayout()
        return super.drawText(in: UIEdgeInsetsInsetRect(rect, insets))
    }
    
}
