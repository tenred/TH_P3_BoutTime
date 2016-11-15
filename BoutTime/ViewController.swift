//
//  ViewController.swift
//  BoutTime
//
//  Created by Sherief Wissa on 14/11/16.
//  Copyright © 2016 10 Red Hacks Pty Ltd. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    //
    @IBOutlet var eventLabelCollection: [UILabel]!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // ViewController to become first responder to shake event.
        self.becomeFirstResponder()
        
        UIStateFirstLoad()
    }
    
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        //Override function to respond to shake action.
        
        print("Shakey Shakey")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func UIStateFirstLoad() {
    // Function loads the default UI state with app is first launched.
        
        for label in eventLabelCollection {
            label.layer.masksToBounds = true
            label.layoutMargins = UIEdgeInsetsMake(-20, -20,0,0)
        }
    }
}

